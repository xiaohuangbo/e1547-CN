import 'package:e1547/markup/data/types.dart';
import 'package:petitparser/petitparser.dart';

// DText grammar.
//
// DText is the markup format used on e621-family sites. The reference
// implementation is `e621ng/dtext` (a Ruby gem whose core is a Ragel state
// machine in `ext/dtext/dtext.cpp.rl`, wrapped by `lib/dtext.rb`). Comments
// in this file cite it directly:
//   "ragel rule X" cites the state machine in `dtext.cpp.rl`.
//   "ruby does Y" cites the surrounding code in `dtext.rb`.
//
// Conformance is checked under `test/markup/conformance/` by diffing this
// parser's AST against a TypeScript port (dmark) as a practical stand-in
// for the Ruby reference. dmark is a proxy oracle for the test harness,
// not the spec, and is not mentioned in this file.
//
// Two AST-shape choices below intentionally do not mimic any other parser:
//   1. Stray block closes (`[/code]`, `[/table]`) emit a `literal_html`
//      node with `prefix` set to the close tag and an empty `children`
//      list, so the stray close stays a typed AST node.
//   2. On full parse failure we emit a single `raw_block_text` block
//      holding the input verbatim, keeping the AST well-typed.
class DTextGrammar {
  late final Parser<DTextDocument> _document = _buildDocument();

  // Built once during _buildDocument, used by parse-time callbacks
  // (_parseInline, _buildLTableChildren) that previously rebuilt the
  // sub-grammar on every invocation.
  late final Parser<List<DTextInline>> _inlineStarEnd;
  late final Parser<DTextTable> _innerTable;

  Parser<DTextDocument> build() => _document;

  /// The built root parser. Exposed for benchmark / profile harnesses that
  /// wrap the tree with `petitparser.debug.profile`.
  Parser<DTextDocument> get rootParser => _document;

  // e621ng/dtext caps combined [sup]/[sub] nesting at [_supSubMaxDepth]
  // (ragel `parse_basic_inline`); opens past the cap drop the wrapper and
  // emit a `DTextFragment` instead. Depth is shared across sup and sub.
  int _supSubDepth = 0;
  static const int _supSubMaxDepth = 3;

  // Stack of close-tag names whose containers are currently open around the
  // parse cursor. Push on entering a container body, pop on exit. The
  // paragraph terminator only stops at a close tag whose name is on this
  // stack; closes with no matching open get absorbed into the paragraph as
  // literal text, matching the reference's "stray close stays inline"
  // behavior.
  final List<String> _activeCloses = [];

  // While > 0, any inline container (`[b]`, `[color=red]`, …) parsed by
  // [_inlineContainerBody] stops at the first `\n`/`\r` instead of the
  // blank-line stop. Headers set this so an unclosed inline inside a
  // header does not eat past the newline that ends the header line.
  int _singleNewlineDepth = 0;

  DTextDocument parse(String input) {
    _supSubDepth = 0;
    _activeCloses.clear();
    _singleNewlineDepth = 0;
    final sanitised = _hasUnencodableScalar(input) ? '' : input;
    final result = _document.parse(sanitised);
    if (result is Success<DTextDocument>) {
      return _capThumbIdType(result.value);
    }
    return DTextDocument([DTextRawBlockText(sanitised)]);
  }

  // e621ng/dtext only renders the first 10 `thumb #N` references in a
  // document as actual thumbnails; subsequent ones fall back to regular
  // post id-links.
  static const int _thumbCap = 10;

  static DTextDocument _capThumbIdType(DTextDocument doc) {
    final counter = [0];
    return DTextDocument([
      for (final b in doc.children) _capBlockThumbs(b, counter),
    ]);
  }

  static DTextBlock _capBlockThumbs(DTextBlock block, List<int> counter) {
    return switch (block) {
      DTextParagraph(:final children) => DTextParagraph(
        _capInlineThumbs(children, counter),
      ),
      DTextHeader(:final level, :final children) => DTextHeader(
        level: level,
        children: _capInlineThumbs(children, counter),
      ),
      DTextQuote(:final children, :final color) => DTextQuote(
        children: [for (final b in children) _capBlockThumbs(b, counter)],
        color: color,
      ),
      DTextSpoilerBlock(:final children) => DTextSpoilerBlock([
        for (final b in children) _capBlockThumbs(b, counter),
      ]),
      DTextSection(:final children, :final title, :final expanded) =>
        DTextSection(
          children: [for (final b in children) _capBlockThumbs(b, counter)],
          title: title,
          expanded: expanded,
        ),
      DTextList(:final items) => DTextList([
        for (final item in items)
          DTextListItem(
            depth: item.depth,
            children: _capInlineThumbs(item.children, counter),
          ),
      ]),
      DTextTable(:final children) => DTextTable([
        for (final c in children) _capTableChildThumbs(c, counter),
      ]),
      DTextLTable(:final children, :final source) => DTextLTable(
        children: [for (final c in children) _capTableChildThumbs(c, counter)],
        source: source,
      ),
      DTextLiteralHtml(:final prefix, :final children) => DTextLiteralHtml(
        prefix: prefix,
        children: _capInlineThumbs(children, counter),
      ),
      DTextCodeBlock() || DTextRawBlockText() => block,
    };
  }

  static DTextTableChild _capTableChildThumbs(
    DTextTableChild child,
    List<int> counter,
  ) {
    return switch (child) {
      DTextTableHead(:final rows) => DTextTableHead([
        for (final r in rows) _capTableChildThumbs(r, counter),
      ]),
      DTextTableBody(:final rows) => DTextTableBody([
        for (final r in rows) _capTableChildThumbs(r, counter),
      ]),
      DTextTableRow(:final cells) => DTextTableRow([
        for (final c in cells)
          DTextTableCell(
            cellType: c.cellType,
            children: _capInlineThumbs(c.children, counter),
          ),
      ]),
      DTextTableLiteral() => child,
    };
  }

  static List<DTextInline> _capInlineThumbs(
    List<DTextInline> nodes,
    List<int> counter,
  ) {
    final out = <DTextInline>[];
    for (final node in nodes) {
      switch (node) {
        case DTextLink(
              linkType: DTextLinkType.idLink,
              idType: DTextIdType.thumb,
              :final id,
              :final href,
              :final children,
            )
            when counter[0] >= _thumbCap:
          out.add(
            DTextLink(
              linkType: DTextLinkType.idLink,
              idType: DTextIdType.post,
              id: id,
              href: href,
              children: children,
            ),
          );
        case DTextLink(
          linkType: DTextLinkType.idLink,
          idType: DTextIdType.thumb,
        ):
          counter[0]++;
          out.add(node);
        case DTextBold(:final children):
          out.add(DTextBold(_capInlineThumbs(children, counter)));
        case DTextItalic(:final children):
          out.add(DTextItalic(_capInlineThumbs(children, counter)));
        case DTextStrikeout(:final children):
          out.add(DTextStrikeout(_capInlineThumbs(children, counter)));
        case DTextUnderline(:final children):
          out.add(DTextUnderline(_capInlineThumbs(children, counter)));
        case DTextSuperscript(:final children):
          out.add(DTextSuperscript(_capInlineThumbs(children, counter)));
        case DTextSubscript(:final children):
          out.add(DTextSubscript(_capInlineThumbs(children, counter)));
        case DTextInlineSpoiler(:final children):
          out.add(DTextInlineSpoiler(_capInlineThumbs(children, counter)));
        case DTextColor(:final color, :final children):
          out.add(
            DTextColor(
              color: color,
              children: _capInlineThumbs(children, counter),
            ),
          );
        case DTextFragment(:final children, :final wrapper):
          out.add(
            DTextFragment(
              children: _capInlineThumbs(children, counter),
              wrapper: wrapper,
            ),
          );
        default:
          out.add(node);
      }
    }
    return out;
  }

  static final RegExp _idLinkInTextRegex = _buildIdLinkRegex();

  // First-letter bitmap (both cases) of every id-link prefix; used by
  // [_TextRunParser._scan] as a cheap pre-filter for the regex peek.
  // Indexed by code unit so the lookup is a single bounds-checked load.
  static final List<bool> _idLinkStartCodes = _buildIdLinkStartCodes();

  static List<bool> _buildIdLinkStartCodes() {
    final out = List<bool>.filled(128, false);
    for (final key in _idPatterns.keys) {
      final c = key.codeUnitAt(0);
      out[c] = true;
      if (c >= 0x61 && c <= 0x7a) {
        out[c - 0x20] = true;
      } else if (c >= 0x41 && c <= 0x5a) {
        out[c + 0x20] = true;
      }
    }
    return out;
  }

  static RegExp _buildIdLinkRegex() {
    final keys = _idPatterns.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    return RegExp(
      r'\b(' + keys.map(RegExp.escape).join('|') + r') #(\d+)',
      caseSensitive: false,
    );
  }

  static DTextIdType _idTypeFromPrefix(String raw) {
    final normalised = raw.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final mapped = _idPatterns[normalised];
    if (mapped != null) return mapped;
    throw StateError('unknown id-link prefix: $raw');
  }

  Parser<DTextDocument> _buildDocument() {
    final block = undefined<DTextBlock>();
    final inline = undefined<DTextInline>();

    inline.set(_buildInline(inline));
    block.set(_buildBlock(block, inline));

    _inlineStarEnd = inline.star().end();
    _innerTable = _tableBlock(inline).end();

    final precededBlock = (
      _blockSeparator().star(),
      block,
    ).toSequenceParser().map((parts) => parts.$2);
    return (
      precededBlock.star(),
      _blockSeparator().star(),
      endOfInput(),
    ).toSequenceParser().map((parts) => DTextDocument(parts.$1));
  }

  Parser<void> _blockSeparator() => _NewlineParser();

  Parser<DTextBlock> _buildBlock(
    SettableParser<DTextBlock> block,
    SettableParser<DTextInline> inline,
  ) {
    final paragraph = _paragraph(inline);
    final headerBlock = _header(inline).map<DTextBlock>((h) => h);
    final listBlock = _list(inline).map<DTextBlock>((l) => l);
    final bracketBlock = [
      _codeBlock(),
      _quoteBlock(block),
      _sectionBlock(block),
      _spoilerBlock(block),
      _tableBlock(inline),
      _ltableBlock(inline),
      _strayBlockClose(),
    ].toChoiceParser();
    final strayClose = _strayClosePassthrough();
    // First-character dispatch: only run a named-block family when its
    // starter is at the cursor, otherwise fall straight through to
    // paragraph / strayClose without paying for each `.and()` peek.
    return _BlockDispatchParser(
      headerBlock: headerBlock,
      listBlock: listBlock,
      bracketBlock: bracketBlock,
      paragraph: paragraph,
      strayClose: strayClose,
    );
  }

  Parser<DTextInline> _buildInline(SettableParser<DTextInline> inline) {
    // _bracketedInline runs eight `[tag]` attempts and is the most
    // expensive fall-through. Every parser with a different first char
    // (`h` for `_inlineUrl`, letters for `_magicIdLink`, `<`, `{`, `"`)
    // fast-fails on prefix, so put them ahead of the bracket family.
    // Within the `[` family `_wikiLink` (`[[`) and `_internalAnchor`
    // (`[#`) precede `_bracketedInline` for the same reason.
    return [
      _TextRunParser(),
      _lineBreak(),
      _bareCarriageReturn(),
      _escape(),
      _inlineCode(),
      _inlineUrl(),
      _magicIdLink(),
      _delimitedUrl(),
      _postSearchLink(),
      _textileLink(inline),
      _wikiLink(inline),
      _internalAnchor(),
      _bracketedInline(inline),
      _text(),
    ].toChoiceParser();
  }

  Parser<DTextInline> _magicIdLink() => _MagicIdLinkParser();

  Parser<DTextHeader> _header(SettableParser<DTextInline> inline) {
    final headerOpen = (
      char('h', ignoreCase: true),
      pattern('1-6').map(int.parse),
      char('.'),
      pattern(' \t').star(),
    ).toSequenceParser();
    return (headerOpen, _withSingleNewlineStop(_inlineUntilNewline(inline)))
        .toSequenceParser()
        .map((parts) => DTextHeader(level: parts.$1.$2, children: parts.$2));
  }

  Parser<T> _withSingleNewlineStop<T>(Parser<T> body) {
    return body.callCC<T>((continuation, context) {
      _singleNewlineDepth++;
      try {
        return continuation(context);
      } finally {
        _singleNewlineDepth--;
      }
    });
  }

  Parser<List<DTextInline>> _inlineUntilNewline(
    SettableParser<DTextInline> inline,
  ) => inline
      .starLazy(
        [
          char('\n'),
          char('\r'),
          _closingTagLookahead(),
          endOfInput(),
        ].toChoiceParser(),
      )
      .map(_mergeAdjacentText);

  Parser<DTextCodeBlock> _codeBlock() =>
      (
        _tagOpen('code'),
        char('\n').optional(),
        any().starLazy(_tagClose('code')).flatten(),
        _tagClose('code'),
      ).toSequenceParser().map((parts) {
        // e621ng/dtext strips leading horizontal whitespace and any leading
        // line break from code-block content, but keeps trailing whitespace.
        // A code body that's nothing but whitespace collapses to an empty
        // string.
        final raw = parts.$3;
        var start = 0;
        while (start < raw.length) {
          final c = raw.codeUnitAt(start);
          if (c == 0x20 || c == 0x09) {
            start++;
          } else if (c == 0x0a || c == 0x0d) {
            start++;
          } else {
            break;
          }
        }
        final content = start == 0 ? raw : raw.substring(start);
        return DTextCodeBlock(content);
      });

  Parser<DTextQuote> _quoteBlock(SettableParser<DTextBlock> block) {
    final open = (
      string('[quote', ignoreCase: true),
      (
        char('='),
        pattern('^]\n').starString(),
      ).toSequenceParser().map((p) => p.$2).optional(),
      char(']'),
      _optionalNewline(),
    ).toSequenceParser().map<String?>((parts) => parts.$2);
    return (
      open,
      _withActiveClose(
        'quote',
        _blocksUntilOptionalClose(block, _tagClose('quote')),
      ),
      _tagClose('quote').optional(),
      // e621ng/dtext eats trailing horizontal whitespace on the line that
      // holds `[/quote]`, so `[/quote] \n\nfoo` parses to two children, not
      // three.
      pattern(' \t').star(),
    ).toSequenceParser().map(
      (parts) => DTextQuote(children: parts.$2, color: parts.$1),
    );
  }

  Parser<DTextSection> _sectionBlock(SettableParser<DTextBlock> block) {
    final expandedTitle = (
      string('[section,expanded=', ignoreCase: true),
      pattern('^]').starString(),
      char(']'),
    ).toSequenceParser().map((parts) => (parts.$2, true));
    final expandedNoTitle = (string(
      '[section,expanded]',
      ignoreCase: true,
    )).map((_) => (null as String?, true));
    final titleOnly = (
      string('[section=', ignoreCase: true),
      pattern('^]').starString(),
      char(']'),
    ).toSequenceParser().map((parts) => (parts.$2 as String?, null as bool?));
    final plain = (string(
      '[section]',
      ignoreCase: true,
    )).map((_) => (null as String?, null as bool?));
    final open = [
      expandedTitle.map((e) => (e.$1 as String?, e.$2 as bool?)),
      expandedNoTitle,
      titleOnly,
      plain,
    ].toChoiceParser();
    return (
      open,
      _optionalNewline(),
      _withActiveClose(
        'section',
        _blocksUntilOptionalClose(block, _tagClose('section')),
      ),
      _tagClose('section').optional(),
      // Same trailing-whitespace fold as [_quoteBlock]; see comment there.
      pattern(' \t').star(),
    ).toSequenceParser().map(
      (parts) => DTextSection(
        children: parts.$3,
        title: parts.$1.$1,
        expanded: parts.$1.$2,
      ),
    );
  }

  Parser<DTextSpoilerBlock> _spoilerBlock(SettableParser<DTextBlock> block) {
    final open = (
      char('['),
      string('spoiler', ignoreCase: true),
      char('s', ignoreCase: true).optional(),
      char(']'),
    ).toSequenceParser();
    final close = (
      char('['),
      char('/'),
      string('spoiler', ignoreCase: true),
      char('s', ignoreCase: true).optional(),
      char(']'),
    ).toSequenceParser();
    return (
      open,
      _optionalNewline(),
      _withActiveClose(const [
        'spoiler',
        'spoilers',
      ], _blocksUntilOptionalClose(block, close)),
      close.optional(),
    ).toSequenceParser().map((parts) => DTextSpoilerBlock(parts.$3));
  }

  // e621ng/dtext allows `[section]`, `[quote]`, `[spoiler]` to run
  // unterminated to EOF. The block emits whatever content was found and
  // the caller treats the close as `.optional()` so the open is never the
  // cause of a top-level parse failure.
  Parser<List<DTextBlock>> _blocksUntilOptionalClose(
    SettableParser<DTextBlock> block,
    Parser<Object?> terminator,
  ) {
    // e621ng/dtext tolerates inter-block whitespace and trailing horizontal
    // whitespace on the close-tag's own line: `[/ltable] [/section]` and
    // `[/code]   \n[/section]` both close cleanly.
    final trailingTail = (
      (pattern(' \t').star(), _blockSeparator()).toSequenceParser().star(),
      pattern(' \t').star(),
    ).toSequenceParser();
    // Zero-or-more separator (not `starSeparated(\n+)`) lets blocks sit
    // back-to-back on the same line: `paragraph [code]x[/code]\n[/section]`
    // keeps paragraph + code together before the close lookahead fires.
    final guarded = (
      _blockSeparator().star(),
      terminator.and().not(),
      block,
    ).toSequenceParser().map((parts) => parts.$3);
    final tail = (
      trailingTail,
      [terminator.and(), endOfInput()].toChoiceParser(),
    ).toSequenceParser();
    return (guarded.star(), tail).toSequenceParser().map((parts) => parts.$1);
  }

  // Orphan close tags (`[/section]` etc. with no matching open in scope)
  // emit as a literal-text paragraph. The [_blocksUntilOptionalClose]
  // terminator guard keeps this from stealing a properly-paired close
  // inside a container.
  Parser<DTextBlock> _strayClosePassthrough() =>
      (
        char('['),
        char('/'),
        [
          string('section', ignoreCase: true),
          string('quote', ignoreCase: true),
          string('spoilers', ignoreCase: true),
          string('spoiler', ignoreCase: true),
          string('ltable', ignoreCase: true),
          string('thead', ignoreCase: true),
          string('tbody', ignoreCase: true),
          string('tr', ignoreCase: true),
          string('td', ignoreCase: true),
          string('th', ignoreCase: true),
        ].toChoiceParser(),
        char(']'),
      ).toSequenceParser().flatten().map(
        (text) => DTextParagraph([DTextText(text)]),
      );

  Parser<DTextTable> _tableBlock(SettableParser<DTextInline> inline) {
    final open = _tagOpen('table');
    final close = _tagClose('table');
    return (
      open,
      _tableChildren(inline, close),
      close.optional(),
    ).toSequenceParser().map((parts) => DTextTable(parts.$2));
  }

  Parser<DTextLTable> _ltableBlock(SettableParser<DTextInline> inline) {
    final open = _tagOpen('ltable');
    final close = _tagClose('ltable');
    return (
      open,
      any().starLazy(close).flatten(),
      close,
    ).toSequenceParser().map((parts) {
      final source = parts.$2.trim();
      return DTextLTable(
        children: _buildLTableChildren(source, inline),
        source: source.isEmpty ? null : source,
      );
    });
  }

  // e621ng/dtext runs a ruby preprocessing pass that rewrites every
  // `[ltable]...[/ltable]` to a synthetic `[table]...[/table]` string before
  // the ragel parser sees it, which lets inline rules (notably `[code]` and
  // `\`...\``) scan across what used to be the pipe boundary in the ltable
  // source. Mirror that: synthesise the table string, run our regular
  // `_tableBlock` on it, and return its children.
  List<DTextTableChild> _buildLTableChildren(
    String source,
    SettableParser<DTextInline> inline,
  ) {
    if (source.isEmpty) return const [];
    final synthesised = _synthesiseLTable(source);
    if (synthesised.isEmpty) return const [];
    final result = _innerTable.parse(synthesised);
    if (result is Success<DTextTable>) {
      return result.value.children;
    }
    return const [];
  }

  static String _synthesiseLTable(String source) {
    final lines = source.split('\n');
    if (lines.isEmpty) return '';
    final buf = StringBuffer('[table]');
    for (var i = 0; i < lines.length; i++) {
      final cols = _splitOnUnescapedPipe(lines[i]);
      final tag = i == 0 ? 'th' : 'td';
      final cells = StringBuffer();
      for (final col in cols) {
        cells
          ..write('[')
          ..write(tag)
          ..write(']')
          ..write(col)
          ..write('[/')
          ..write(tag)
          ..write(']');
      }
      if (i == 0) {
        buf
          ..write('[thead][tr]')
          ..write(cells)
          ..write('[/tr][/thead][tbody]');
      } else {
        buf
          ..write('[tr]')
          ..write(cells)
          ..write('[/tr]');
      }
    }
    buf.write('[/tbody][/table]');
    return buf.toString();
  }

  // Used for textile link titles and ltable cell bodies. e621ng/dtext pushes
  // inline-document and table-cell parse results onto their children list
  // without merging adjacent text, so a `[` followed by `image]` stays as
  // two text nodes, not one.
  List<DTextInline> _parseInline(
    String input,
    SettableParser<DTextInline> inline,
  ) {
    if (input.isEmpty) return const [];
    final result = _inlineStarEnd.parse(input);
    if (result is Success<List<DTextInline>>) return result.value;
    return [DTextText(input)];
  }

  Parser<List<DTextTableChild>> _tableChildren(
    SettableParser<DTextInline> inline,
    Parser<Object?> tableClose,
  ) {
    final cellTh = _tableCell('th', DTextTableCellType.th, inline);
    final cellTd = _tableCell('td', DTextTableCellType.td, inline);
    // e621ng/dtext's table-row scope swallows any non-cell content one
    // char at a time and keeps walking until it hits `[/tr]` or end.
    // Mirror that with a single-char fallback inside the row's choice so
    // a stray wiki link between cells does not stop the row collector
    // early.
    final rowStray = (
      _tagClose('tr').and().not(),
      any(),
    ).toSequenceParser().map<Object?>((_) => null);
    final row =
        (
          _ws(),
          _tagOpen('tr'),
          [cellTh, cellTd, _whitespaceRun(), rowStray]
              .toChoiceParser()
              .starLazy([_tagClose('tr'), tableClose].toChoiceParser()),
          _tagClose('tr').optional(),
        ).toSequenceParser().map<DTextTableChild>(
          (parts) =>
              DTextTableRow(parts.$3.whereType<DTextTableCell>().toList()),
        );
    // e621ng/dtext tolerates a missing `[/thead]` / `[/tbody]` close
    // inside a table, so the close is optional here. The choices below
    // stop when no row or cell matches and the outer table's close
    // lookahead steps in.
    final head =
        (
          _ws(),
          _tagOpen('thead'),
          [row, cellTh, cellTd, _whitespaceRun()].toChoiceParser().star(),
          _tagClose('thead').optional(),
        ).toSequenceParser().map<DTextTableChild>(
          (parts) => DTextTableHead(_wrapBareCells(parts.$3)),
        );
    // e621ng/dtext keeps a nested `[thead]` inside `[tbody]` rather than
    // closing the body, so the head shows up as one of the body's rows.
    // Mirror that by allowing `head` inside the body's star.
    final body =
        (
          _ws(),
          _tagOpen('tbody'),
          [head, row, cellTh, cellTd, _whitespaceRun()].toChoiceParser().star(),
          _tagClose('tbody').optional(),
        ).toSequenceParser().map<DTextTableChild>(
          (parts) => DTextTableBody(_wrapBareCells(parts.$3)),
        );
    // Real-world tables sometimes have stray text between cells (e.g. a
    // typo `[/td]No.[td]`). Consume a single char as last resort so the
    // table close lookahead always advances; e621ng/dtext also swallows
    // these fragments rather than failing the whole block.
    final stray = any().map<Object?>((_) => null);
    return [
      head,
      body,
      row,
      cellTh,
      cellTd,
      _whitespaceRun(),
      stray,
    ].toChoiceParser().starLazy(tableClose).map(_wrapBareCells);
  }

  // e621ng/dtext wraps bare cells (`[th]a[/th][th]b[/th]` inside a `[thead]`
  // with no explicit `[tr]`) in an implicit row. Existing rows pass through.
  static List<DTextTableChild> _wrapBareCells(List<Object?> items) {
    final out = <DTextTableChild>[];
    List<DTextTableCell>? pendingCells;
    void flush() {
      if (pendingCells == null) return;
      out.add(DTextTableRow(pendingCells!));
      pendingCells = null;
    }

    for (final item in items) {
      if (item is DTextTableCell) {
        pendingCells ??= <DTextTableCell>[];
        pendingCells!.add(item);
      } else if (item is DTextTableChild) {
        flush();
        out.add(item);
      }
    }
    flush();
    return out;
  }

  Parser<Object?> _whitespaceRun() =>
      pattern(' \t\r\n').plus().map((_) => null);

  // Table cells deliberately skip [_mergeAdjacentText]: e621ng/dtext pushes
  // inline elements directly onto the cell's children list, so a `[image of`
  // sequence (where the inline text scanner emits a one-char `[` then a
  // multi-char run) stays as two text nodes, not one.
  Parser<Object?> _tableCell(
    String tag,
    DTextTableCellType cellType,
    SettableParser<DTextInline> inline,
  ) => (_ws(), _tagOpen(tag), inline.starLazy(_tagClose(tag)), _tagClose(tag))
      .toSequenceParser()
      .map<Object?>(
        (parts) => DTextTableCell(
          cellType: cellType,
          children: _trimTrailingLineBreaks(parts.$3),
        ),
      );

  Parser<void> _ws() => pattern(' \t\r\n').star();

  Parser<DTextList> _list(SettableParser<DTextInline> inline) {
    // e621ng/dtext slices each list item to a single line, then parses
    // the slice as inline, truncating at the first in-scope block close.
    // Mirror both: capture chars up to a newline or list-line stop tag,
    // then [_parseInline] the slice. Unclosed `[sub]` inside the slice
    // cannot escape; a stray `[/section]` stays in the outer stream for
    // the surrounding section.
    //
    // The line scanner is a custom parser (see [_ListLineParser]) because
    // running `(stop.not(), pattern('^\n\r')).toSequenceParser()` per char
    // dominated profile time on list-heavy fixtures.
    final lineBody = _ListLineParser();
    final item =
        (
          char('*').plusString(),
          char(' ').plus(),
          lineBody.map(
            (line) => _mergeAdjacentText(_parseInline(line, inline)),
          ),
        ).toSequenceParser().map(
          (parts) => DTextListItem(depth: parts.$1.length, children: parts.$3),
        );
    return item
        .plusSeparated(_blockSeparator())
        .map((sep) => DTextList(sep.elements.toList()));
  }

  Parser<DTextLiteralHtml> _strayBlockClose() =>
      (
        string('[/', ignoreCase: true),
        [
          string('code', ignoreCase: true),
          string('table', ignoreCase: true),
        ].toChoiceParser(),
        char(']'),
      ).toSequenceParser().flatten().map(
        (text) => DTextLiteralHtml(prefix: text, children: const []),
      );

  Parser<DTextParagraph> _paragraph(SettableParser<DTextInline> inline) {
    final terminator = _paragraphTerminator();
    return (
      terminator.not(),
      inline.plusLazy(terminator),
    ).toSequenceParser().map(
      (parts) =>
          DTextParagraph(_trimTrailingLineBreaks(_mergeAdjacentText(parts.$2))),
    );
  }

  // `plusLazy` in [_paragraph] consumes one inline node unconditionally
  // before checking this terminator; the `terminator.not()` guard at the
  // start of [_paragraph] is what stops stray closes at block boundaries.
  Parser<void> _paragraphTerminator() {
    final newlineLed = (
      [char('\n'), char('\r')].toChoiceParser().and(),
      [_blankLineLookahead(), _blockOpenerLookahead()].toChoiceParser(),
    ).toSequenceParser().map((_) => null);
    // When an inline container (italic, color, etc.) ate the blank line
    // that would have separated blocks, the cursor lands on the next
    // block's opener with no `\n` left for [newlineLed] to see. Recover by
    // also stopping when we are at line start and the next chars open a
    // header or list.
    final lineStartBlockOpener = (
      _atLineStartLookahead(),
      [_headerOpenLookahead(), _listOpenLookahead()].toChoiceParser(),
    ).toSequenceParser().map((_) => null);
    return [
      newlineLed,
      lineStartBlockOpener,
      _alwaysStopCloseLookahead(),
      _activeCloseLookahead(),
      _blockTagOpenLookahead(),
      endOfInput(),
    ].toChoiceParser();
  }

  // Block-level closes that always terminate a paragraph, regardless of
  // whether any matching container is open. `[/code]` and `[/table]` get
  // promoted to a `literal_html` block in their own right by
  // [_strayBlockClose], so they need to break the paragraph even at top
  // level.
  Parser<void> _alwaysStopCloseLookahead() => (
    char('['),
    char('/'),
    [
      string('code', ignoreCase: true),
      string('table', ignoreCase: true),
    ].toChoiceParser(),
    char(']'),
  ).toSequenceParser().and();

  // Container-level closes that only stop the paragraph when a matching
  // container is open around the cursor. Stray closes (`body [/quote]` at
  // top level) fall through to plain text in the surrounding paragraph.
  // ignore: use_to_and_as_if_applicable
  Parser<void> _activeCloseLookahead() => _ActiveCloseLookaheadParser(this);

  // Pushes [names] onto [_activeCloses] for the duration of [body], then
  // pops them. Multiple names cover containers whose close has spelling
  // variants (e.g. `[/spoiler]` and `[/spoilers]` both close `[spoiler]`).
  Parser<T> _withActiveClose<T>(Object names, Parser<T> body) {
    final list = names is List<String> ? names : [names as String];
    return body.callCC<T>((continuation, context) {
      _activeCloses.addAll(list);
      try {
        return continuation(context);
      } finally {
        for (var i = 0; i < list.length; i++) {
          _activeCloses.removeLast();
        }
      }
    });
  }

  static List<DTextInline> _trimTrailingLineBreaks(List<DTextInline> nodes) {
    var end = nodes.length;
    while (end > 0 && nodes[end - 1] is DTextLineBreak) {
      end--;
    }
    if (end == nodes.length) return nodes;
    return nodes.sublist(0, end);
  }

  // e621ng/dtext only treats `\n\n` (with no whitespace between the
  // newlines) as a blank-line paragraph break; `\n \n` is a line break
  // followed by a whitespace-only line that stays inside the same
  // paragraph. The `\r?` permits CRLF sources to terminate paragraphs at
  // `\r\n\r\n`.
  Parser<void> _blankLineLookahead() => (
    char('\r').optional(),
    char('\n'),
    char('\r').optional(),
    char('\n'),
  ).toSequenceParser().and();

  Parser<void> _blockOpenerLookahead() => (
    char('\r').optional(),
    char('\n'),
    [
      _blockTagOpenLookahead(),
      _listOpenLookahead(),
      _headerOpenLookahead(),
    ].toChoiceParser(),
  ).toSequenceParser().and();

  // `spoiler`/`spoilers` are omitted: e621ng/dtext treats them as inline,
  // not block, even at line start. Each tag's shape mirrors what its
  // block parser will actually accept, so the lookahead never fires on an
  // opener the block parser will reject (which would strand paragraph
  // parsing in [_BlockDispatchParser]'s fall-through).
  Parser<void> _blockTagOpenLookahead() {
    final quote = (
      string('quote', ignoreCase: true),
      [
        char(']'),
        (char('='), pattern('^]\n').starString(), char(']')).toSequenceParser(),
      ].toChoiceParser(),
    ).toSequenceParser();
    final section = (
      string('section', ignoreCase: true),
      [
        char(']'),
        (char('='), pattern('^]').starString(), char(']')).toSequenceParser(),
        (
          string(',expanded', ignoreCase: true),
          [
            char(']'),
            (
              char('='),
              pattern('^]').starString(),
              char(']'),
            ).toSequenceParser(),
          ].toChoiceParser(),
        ).toSequenceParser(),
      ].toChoiceParser(),
    ).toSequenceParser();
    final plain = [
      string('code]', ignoreCase: true),
      string('table]', ignoreCase: true),
      string('ltable]', ignoreCase: true),
    ].toChoiceParser();
    return (
      char('['),
      <Parser<Object?>>[quote, section, plain].toChoiceParser(),
    ).toSequenceParser().and();
  }

  Parser<void> _listOpenLookahead() =>
      (char('*').plus(), char(' ')).toSequenceParser().and();

  Parser<void> _atLineStartLookahead() => _AtLineStartParser();

  Parser<void> _headerOpenLookahead() => (
    char('h', ignoreCase: true),
    pattern('1-6'),
    char('.'),
  ).toSequenceParser().and();

  Parser<void> _closingTagLookahead() => (
    char('['),
    char('/'),
    [
      string('code', ignoreCase: true),
      string('quote', ignoreCase: true),
      string('section', ignoreCase: true),
      string('spoilers', ignoreCase: true),
      string('spoiler', ignoreCase: true),
      string('table', ignoreCase: true),
      string('ltable', ignoreCase: true),
      string('thead', ignoreCase: true),
      string('tbody', ignoreCase: true),
      string('tr', ignoreCase: true),
      string('td', ignoreCase: true),
      string('th', ignoreCase: true),
    ].toChoiceParser(),
    char(']'),
  ).toSequenceParser().and();

  Parser<DTextInline> _lineBreak() => (
    char('\r').optional(),
    char('\n'),
  ).toSequenceParser().map((_) => const DTextLineBreak());

  // e621ng/dtext renders a bare `\r` (no following `\n`) as a single-space
  // text node (ragel rule `'\r' => append(' ')` in the inline scanner),
  // which the inline text-merging step then folds into the surrounding
  // text run. Non-merging collectors (table cells, textile titles) keep
  // it as its own node because they do not merge at all.
  Parser<DTextInline> _bareCarriageReturn() =>
      char('\r').map((_) => const DTextText(' '));

  Parser<DTextInline> _escape() => (
    char(r'\'),
    char('`'),
  ).toSequenceParser().map((_) => const DTextText('`'));

  Parser<DTextInlineCode> _inlineCode() {
    // Allow `\`` inside inline code as an escaped backtick (e621ng/dtext).
    final escapedBacktick = (
      char(r'\'),
      char('`'),
    ).toSequenceParser().map((_) => '`');
    final plainChar = pattern('^`\n').map((c) => c);
    return (
      char('`'),
      [
        escapedBacktick,
        plainChar,
      ].toChoiceParser().star().map((list) => list.join()),
      char('`'),
    ).toSequenceParser().map((parts) => DTextInlineCode(parts.$2));
  }

  Parser<DTextInline> _bracketedInline(SettableParser<DTextInline> inline) => [
    _simpleInline('b', inline, DTextBold.new),
    _simpleInline('i', inline, DTextItalic.new),
    _simpleInline('s', inline, DTextStrikeout.new),
    _simpleInline('u', inline, DTextUnderline.new),
    _supSubInline(
      'sup',
      inline,
      DTextSuperscript.new,
      DTextFragmentWrapper.sup,
    ),
    _supSubInline('sub', inline, DTextSubscript.new, DTextFragmentWrapper.sub),
    _simpleInline('spoiler', inline, DTextInlineSpoiler.new),
    _colorInline(inline),
  ].toChoiceParser();

  Parser<DTextInline> _simpleInline(
    String tag,
    SettableParser<DTextInline> inline,
    DTextInline Function(List<DTextInline>) build,
  ) {
    final close = _tagClose(tag);
    return (
      _tagOpen(tag),
      _inlineContainerBody(inline, close),
      close.optional(),
    ).toSequenceParser().map((parts) => build(parts.$2));
  }

  Parser<DTextInline> _supSubInline(
    String tag,
    SettableParser<DTextInline> inline,
    DTextInline Function(List<DTextInline>) wrap,
    DTextFragmentWrapper fragmentKind,
  ) {
    final close = _tagClose(tag);
    return (
      _tagOpen(tag).map((_) {
        final dropped = _supSubDepth >= _supSubMaxDepth;
        _supSubDepth++;
        return dropped;
      }),
      _inlineContainerBody(inline, close),
      close.optional(),
    ).toSequenceParser().map((parts) {
      _supSubDepth--;
      final body = parts.$2;
      return parts.$1
          ? DTextFragment(children: body, wrapper: fragmentKind)
          : wrap(body);
    });
  }

  Parser<DTextInline> _colorInline(SettableParser<DTextInline> inline) {
    final close = _tagClose('color');
    return (
      string('[color=', ignoreCase: true),
      pattern('^]\n').plusString(),
      char(']'),
      _inlineContainerBody(inline, close),
      close.optional(),
    ).toSequenceParser().map(
      (parts) => DTextColor(color: parts.$2, children: parts.$4),
    );
  }

  // Body of a `[b]` / `[i]` / `[color=…]` etc. container. e621ng/dtext
  // silently swallows `\n\n` runs inside an inline container and keeps
  // the container open, so `[i]a\n\nb[/i]` yields a single italic span
  // around merged text. The blank-line eater here mirrors that; every
  // other stop matches the surrounding-context exits the ruby parser
  // uses.
  Parser<List<DTextInline>> _inlineContainerBody(
    SettableParser<DTextInline> inline,
    Parser<Object?> close,
  ) {
    // e621ng/dtext re-checks "at line start" after each inline-step, so
    // once a blank-line run lands the cursor at column 0 a list/header
    // marker breaks the container even though no `\n` sits immediately
    // at the cursor. Encode that as a separate stop.
    final lineStartListHeader = (
      _atLineStartLookahead(),
      [_listOpenLookahead(), _headerOpenLookahead()].toChoiceParser(),
    ).toSequenceParser();
    final singleNewlineStop = _SingleNewlineIfFlagParser(this);
    final stop = [
      close,
      _blockOpenerLookahead(),
      _blockTagOpenLookahead(),
      _closingTagLookahead(),
      lineStartListHeader,
      singleNewlineStop,
      endOfInput(),
    ].toChoiceParser();
    final blankEater = (
      char('\r').optional(),
      char('\n'),
      char('\r').optional(),
      char('\n'),
      [
        pattern(' \t'),
        (char('\r').optional(), char('\n')).toSequenceParser(),
      ].toChoiceParser().star(),
    ).toSequenceParser().map<DTextInline?>((_) => null);
    return [blankEater, inline.map<DTextInline?>((n) => n)]
        .toChoiceParser()
        .starLazy(stop)
        .map(
          (list) => _mergeAdjacentText(list.whereType<DTextInline>().toList()),
        );
  }

  Parser<DTextInline> _internalAnchor() => (
    string('[#'),
    pattern('a-zA-Z0-9_-').plusString(),
    char(']'),
  ).toSequenceParser().map((parts) => DTextInternalAnchor(parts.$2));

  Parser<DTextInline> _wikiLink(SettableParser<DTextInline> inline) =>
      (
            string('[['),
            pattern('^]|\n').starString(),
            (
              char('|'),
              pattern('^]\n').starString(),
            ).toSequenceParser().map((p) => p.$2).optional(),
            string(']]'),
          )
          .toSequenceParser()
          .where((parts) {
            final raw = parts.$2;
            final title = parts.$3;
            if (raw.isEmpty && title == null) return false;
            if (title != null && title.isEmpty) return false;
            if (title != null && title.startsWith('|')) return false;
            return true;
          })
          .map((parts) {
            final raw = parts.$2;
            final title = parts.$3;
            String tag = raw;
            String? anchor;
            final hashIdx = raw.indexOf('#');
            if (hashIdx >= 0) {
              tag = raw.substring(0, hashIdx);
              anchor = raw.substring(hashIdx + 1);
            }
            return _buildWikiLink(tag: tag, anchor: anchor, title: title);
          });

  Parser<DTextInline> _postSearchLink() =>
      (
        string('{{'),
        pattern('^}\n').plusString(),
        string('}}'),
      ).toSequenceParser().map((parts) {
        final raw = parts.$2;
        final pipe = raw.indexOf('|');
        final tag = pipe < 0 ? raw : raw.substring(0, pipe);
        final title = pipe < 0 ? null : raw.substring(pipe + 1);
        return _buildPostSearchLink(tag: tag, title: title);
      });

  Parser<DTextInline> _textileLink(SettableParser<DTextInline> inline) =>
      (
        char('"'),
        pattern('^"\n').plusString(),
        string('":'),
        _textileUrl(),
      ).toSequenceParser().map((parts) {
        final title = parts.$2;
        final url = parts.$4;
        return DTextLink(
          linkType: DTextLinkType.inline,
          href: url,
          children: _parseInline(title, inline),
        );
      });

  Parser<String> _textileUrl() => [
    (
      char('['),
      pattern('^]\n').plusString(),
      char(']'),
    ).toSequenceParser().map((parts) => parts.$2),
    (
      [
        string('http://', ignoreCase: true),
        string('https://', ignoreCase: true),
      ].toChoiceParser(),
      _UrlBodyParser(),
    ).toSequenceParser().map((parts) => '${parts.$1}${parts.$2}'),
    (
      char('/'),
      _UrlBodyParser(),
    ).toSequenceParser().map((parts) => '/${parts.$2}'),
    (
      char('#'),
      _UrlBodyParser(),
    ).toSequenceParser().map((parts) => '#${parts.$2}'),
  ].toChoiceParser();

  // Bare URL matcher (ragel `url = 'http'i 's'i? '://' ^space+`). e621ng/dtext
  // breaks out of the text scanner at `h`/`H` + `"http"` and tries this rule.
  // Order in our inline choice matters: this runs after the bracketed-form
  // matchers (`<http…>`, `"…":http…`) so it does not steal their inputs.
  Parser<DTextInline> _inlineUrl() =>
      (
        [
          string('http://', ignoreCase: true),
          string('https://', ignoreCase: true),
        ].toChoiceParser().flatten(),
        _UrlBodyParser(),
      ).toSequenceParser().map((parts) {
        final href = '${parts.$1}${parts.$2}';
        return DTextLink(
          linkType: DTextLinkType.url,
          href: href,
          children: [DTextText(href)],
        );
      });

  Parser<DTextInline> _delimitedUrl() =>
      (
        char('<'),
        [
          string('http://', ignoreCase: true),
          string('https://', ignoreCase: true),
        ].toChoiceParser(),
        pattern('^ \t\n\r\f\v>').plusString(),
        char('>'),
      ).toSequenceParser().map((parts) {
        final href = '${parts.$2}${parts.$3}';
        return DTextLink(
          linkType: DTextLinkType.url,
          href: href,
          children: [DTextText(href)],
        );
      });

  // Single-char fallback. Keeps the inline choice total so a stray trigger
  // char (`[`, `"`, etc.) that no rule consumes always advances by one.
  Parser<DTextInline> _text() => pattern('^\n\r').map(DTextText.new);

  // Used right after a block open tag like `[quote]`, `[section]`,
  // `[spoiler]`. e621ng/dtext eats trailing horizontal whitespace, an
  // optional line break, then any further whitespace-only lines on the
  // same open, so `[section]\n \nh5. foo` doesn't get a `" "`-paragraph
  // between the open and the header.
  Parser<void> _optionalNewline() => (
    pattern(' \t').star(),
    (
      char('\r').optional(),
      char('\n'),
      (pattern(' \t').plus(), _blockSeparator()).toSequenceParser().star(),
    ).toSequenceParser().optional(),
  ).toSequenceParser();

  Parser<Object?> _tagOpen(String tag) =>
      (char('['), string(tag, ignoreCase: true), char(']')).toSequenceParser();

  Parser<Object?> _tagClose(String tag) => (
    char('['),
    char('/'),
    string(tag, ignoreCase: true),
    char(']'),
  ).toSequenceParser();

  static List<DTextInline> _mergeAdjacentText(List<DTextInline> nodes) {
    if (nodes.isEmpty) return nodes;
    final out = <DTextInline>[];
    for (final node in nodes) {
      if (node is DTextText && out.isNotEmpty && out.last is DTextText) {
        final prev = out.last as DTextText;
        out.removeLast();
        out.add(DTextText(prev.content + node.content));
      } else {
        out.add(node);
      }
    }
    return out;
  }

  static bool _hasUnencodableScalar(String input) {
    for (var i = 0; i < input.length; i++) {
      final c = input.codeUnitAt(i);
      if (c == 0) return true;
      if (c >= 0xD800 && c <= 0xDBFF) {
        if (i + 1 >= input.length) return true;
        final next = input.codeUnitAt(i + 1);
        if (next < 0xDC00 || next > 0xDFFF) return true;
        i++;
        continue;
      }
      if (c >= 0xDC00 && c <= 0xDFFF) return true;
    }
    return false;
  }

  static List<String> _splitOnUnescapedPipe(String line) {
    final out = <String>[];
    var start = 0;
    for (var i = 0; i < line.length; i++) {
      if (line.codeUnitAt(i) != 0x7c) continue;
      if (i > 0 && line.codeUnitAt(i - 1) == 0x5c) continue;
      out.add(line.substring(start, i));
      start = i + 1;
    }
    out.add(line.substring(start));
    while (out.isNotEmpty && out.last.isEmpty) {
      out.removeLast();
    }
    return out;
  }

  DTextInline _buildWikiLink({
    required String tag,
    String? anchor,
    String? title,
  }) {
    if (tag.isEmpty && anchor != null) {
      final normalised = _asciiLowercase(anchor.replaceAll(' ', '_'));
      final href = '#${_rubyUriEscape(normalised)}';
      final text = title ?? '#$anchor';
      return DTextLink(
        linkType: DTextLinkType.wiki,
        href: href,
        anchor: anchor,
        children: [DTextText(text)],
      );
    }
    final normalisedTag = _asciiLowercase(tag.replaceAll(' ', '_'));
    var href =
        '/wiki_pages/show_or_new?title=${_rubyUriEscapeWithHash(normalisedTag)}';
    if (anchor != null) {
      final normalisedAnchor = _asciiLowercase(anchor.replaceAll(' ', '_'));
      href = '$href#${_rubyUriEscapeWithHash(normalisedAnchor)}';
    }
    final text = title ?? (anchor != null ? '$tag#$anchor' : tag);
    return DTextLink(
      linkType: DTextLinkType.wiki,
      href: href,
      anchor: anchor,
      children: [DTextText(text)],
    );
  }

  DTextInline _buildPostSearchLink({required String tag, String? title}) {
    final normalised = _asciiLowercase(tag);
    final href = '/posts?tags=${_rubyUriEscape(normalised)}';
    final text = (title == null || title.isEmpty) ? tag : title;
    return DTextLink(
      linkType: DTextLinkType.postSearch,
      tags: normalised,
      href: href,
      children: [DTextText(text)],
    );
  }

  static String _asciiLowercase(String s) {
    final hasUpper = RegExp('[A-Z]').hasMatch(s);
    if (!hasUpper) return s;
    return s.replaceAllMapped(
      RegExp('[A-Z]'),
      (m) => String.fromCharCode(m[0]!.codeUnitAt(0) + 32),
    );
  }

  static String _rubyUriEscape(String s) {
    final buf = StringBuffer();
    for (final code in s.runes) {
      if ((code >= 0x30 && code <= 0x39) ||
          (code >= 0x41 && code <= 0x5a) ||
          (code >= 0x61 && code <= 0x7a) ||
          code == 0x2d ||
          code == 0x5f ||
          code == 0x2e ||
          code == 0x7e) {
        buf.writeCharCode(code);
      } else if (code == 0x20) {
        buf.write('%20');
      } else {
        for (final byte in _utf8Encode(code)) {
          buf.write('%${byte.toRadixString(16).toUpperCase().padLeft(2, '0')}');
        }
      }
    }
    return buf.toString();
  }

  static String _rubyUriEscapeWithHash(String s) =>
      _rubyUriEscape(s).replaceAll('%23', '#');

  static List<int> _utf8Encode(int codePoint) {
    if (codePoint < 0x80) return [codePoint];
    if (codePoint < 0x800) {
      return [0xc0 | (codePoint >> 6), 0x80 | (codePoint & 0x3f)];
    }
    if (codePoint < 0x10000) {
      return [
        0xe0 | (codePoint >> 12),
        0x80 | ((codePoint >> 6) & 0x3f),
        0x80 | (codePoint & 0x3f),
      ];
    }
    return [
      0xf0 | (codePoint >> 18),
      0x80 | ((codePoint >> 12) & 0x3f),
      0x80 | ((codePoint >> 6) & 0x3f),
      0x80 | (codePoint & 0x3f),
    ];
  }

  static const Map<String, DTextIdType> _idPatterns = {
    'post changes': DTextIdType.postChanges,
    'take down request': DTextIdType.takedown,
    'take down': DTextIdType.takedown,
    'takedown request': DTextIdType.takedown,
    'takedown': DTextIdType.takedown,
    'mod action': DTextIdType.modAction,
    'post': DTextIdType.post,
    'thumb': DTextIdType.thumb,
    'flag': DTextIdType.flag,
    'note': DTextIdType.note,
    'forum': DTextIdType.forumPost,
    'topic': DTextIdType.topic,
    'comment': DTextIdType.comment,
    'pool': DTextIdType.pool,
    'user': DTextIdType.user,
    'artist': DTextIdType.artist,
    'ban': DTextIdType.ban,
    'bur': DTextIdType.bur,
    'alias': DTextIdType.alias,
    'implication': DTextIdType.implication,
    'record': DTextIdType.record,
    'wiki': DTextIdType.wiki,
    'set': DTextIdType.set,
    'blip': DTextIdType.blip,
    'ticket': DTextIdType.ticket,
  };

  static const Map<DTextIdType, String> _idDisplay = {
    DTextIdType.post: 'post',
    DTextIdType.thumb: 'post',
    DTextIdType.postChanges: 'post changes',
    DTextIdType.flag: 'flag',
    DTextIdType.note: 'note',
    DTextIdType.forumPost: 'forum',
    DTextIdType.topic: 'topic',
    DTextIdType.comment: 'comment',
    DTextIdType.pool: 'pool',
    DTextIdType.user: 'user',
    DTextIdType.artist: 'artist',
    DTextIdType.ban: 'ban',
    DTextIdType.bur: 'BUR',
    DTextIdType.alias: 'alias',
    DTextIdType.implication: 'implication',
    DTextIdType.modAction: 'mod action',
    DTextIdType.record: 'record',
    DTextIdType.wiki: 'wiki',
    DTextIdType.set: 'set',
    DTextIdType.blip: 'blip',
    DTextIdType.takedown: 'takedown',
    DTextIdType.ticket: 'ticket',
  };

  static const Map<DTextIdType, String> _idRoutes = {
    DTextIdType.post: '/posts/',
    DTextIdType.thumb: '/posts/',
    DTextIdType.postChanges: '/post_versions?search[post_id]=',
    DTextIdType.flag: '/post_flags/',
    DTextIdType.note: '/notes/',
    DTextIdType.forumPost: '/forum_posts/',
    DTextIdType.topic: '/forum_topics/',
    DTextIdType.comment: '/comments/',
    DTextIdType.pool: '/pools/',
    DTextIdType.user: '/users/',
    DTextIdType.artist: '/artists/',
    DTextIdType.ban: '/bans/',
    DTextIdType.bur: '/bulk_update_requests/',
    DTextIdType.alias: '/tag_aliases/',
    DTextIdType.implication: '/tag_implications/',
    DTextIdType.modAction: '/mod_actions/',
    DTextIdType.record: '/user_feedbacks/',
    DTextIdType.wiki: '/wiki_pages/',
    DTextIdType.set: '/post_sets/',
    DTextIdType.blip: '/blips/',
    DTextIdType.takedown: '/takedowns/',
    DTextIdType.ticket: '/tickets/',
  };
}

// URL body matcher: runs of non-whitespace, with a one-char trailing-punct
// trim (`foo.` keeps the period; `foo,` drops the comma). The trimmed char
// stays in the buffer so the next inline parser sees it as plain text.
class _UrlBodyParser extends Parser<String> {
  // Whitespace stop set: space (0x20) plus tab/LF/VT/FF/CR (0x09..0x0d).
  // Inlined as a range check so the hot scan loop avoids a Set hash.
  // e621ng/dtext does not exclude `[` here. `[/i` and similar fragments
  // stay in the URL body and the trailing `]` falls out via punct trim.
  static bool _isStop(int c) => c == 0x20 || (c >= 0x09 && c <= 0x0d);

  // Trailing punctuation virtually never the last char of a real URL.
  // `"` is NOT trimmed: e621ng/dtext keeps a closing quote that lands at
  // the end of a textile URL body in the href, even though it usually looks
  // like a stray character.
  static const Set<int> _trailingPunct = {
    0x2c, 0x2e, 0x3b, 0x3a, 0x21, 0x3f, // , . ; : ! ?
    0x27, // '
    0x29, 0x5d, 0x7d, // ) ] }
  };

  // e621ng/dtext strips exactly one trailing punctuation char, never two;
  // `foo.,` becomes `foo.`, not `foo`. Loop would over-trim.
  static int _trimEnd(String buffer, int start, int end) {
    if (end <= start) return end;
    final c = buffer.codeUnitAt(end - 1);
    if (_trailingPunct.contains(c)) return end - 1;
    return end;
  }

  @override
  Result<String> parseOn(Context context) {
    final buffer = context.buffer;
    final start = context.position;
    var end = start;
    while (end < buffer.length) {
      final c = buffer.codeUnitAt(end);
      if (_isStop(c)) break;
      end++;
    }
    if (end == start) return context.failure('url body expected');
    end = _trimEnd(buffer, start, end);
    if (end == start) return context.failure('url body expected');
    return context.success(buffer.substring(start, end), end);
  }

  @override
  int fastParseOn(String buffer, int position) {
    var end = position;
    while (end < buffer.length) {
      final c = buffer.codeUnitAt(end);
      if (_isStop(c)) break;
      end++;
    }
    if (end == position) return -1;
    end = _trimEnd(buffer, position, end);
    if (end == position) return -1;
    return end;
  }

  @override
  _UrlBodyParser copy() => _UrlBodyParser();
}

// Matches a close tag `[/<name>]` at the cursor only when <name> is on the
// grammar's [_activeCloses] stack. Used by the paragraph terminator so a
// stray close that does not correspond to any open container is absorbed
// into the paragraph as literal text instead of splitting it.
class _ActiveCloseLookaheadParser extends Parser<void> {
  _ActiveCloseLookaheadParser(this.grammar);

  final DTextGrammar grammar;

  @override
  Result<void> parseOn(Context ctx) {
    final stack = grammar._activeCloses;
    if (stack.isEmpty) return ctx.failure('no active container');
    final buf = ctx.buffer;
    final pos = ctx.position;
    final len = buf.length;
    if (pos + 3 >= len) return ctx.failure('not a close tag');
    if (buf.codeUnitAt(pos) != 0x5b) return ctx.failure('expected [');
    if (buf.codeUnitAt(pos + 1) != 0x2f) return ctx.failure('expected /');
    var end = pos + 2;
    while (end < len && buf.codeUnitAt(end) != 0x5d) {
      end++;
    }
    if (end >= len) return ctx.failure('no closing ]');
    final name = buf.substring(pos + 2, end).toLowerCase();
    for (var i = 0; i < stack.length; i++) {
      if (stack[i] == name) return ctx.success(null, pos);
    }
    return ctx.failure('close tag not active');
  }

  @override
  int fastParseOn(String buf, int pos) {
    final stack = grammar._activeCloses;
    if (stack.isEmpty) return -1;
    final len = buf.length;
    if (pos + 3 >= len) return -1;
    if (buf.codeUnitAt(pos) != 0x5b) return -1;
    if (buf.codeUnitAt(pos + 1) != 0x2f) return -1;
    var end = pos + 2;
    while (end < len && buf.codeUnitAt(end) != 0x5d) {
      end++;
    }
    if (end >= len) return -1;
    final name = buf.substring(pos + 2, end).toLowerCase();
    for (var i = 0; i < stack.length; i++) {
      if (stack[i] == name) return pos;
    }
    return -1;
  }

  @override
  Parser<void> copy() => _ActiveCloseLookaheadParser(grammar);
}

// Lookahead that matches `\n` or `\r` when [DTextGrammar._singleNewlineDepth]
// is positive. Lets an inline container parsed inside a header stop at the
// header's terminating newline so an unclosed `[color=red]` does not bleed
// the following line into the header.
class _SingleNewlineIfFlagParser extends Parser<void> {
  _SingleNewlineIfFlagParser(this.grammar);

  final DTextGrammar grammar;

  @override
  Result<void> parseOn(Context ctx) {
    if (grammar._singleNewlineDepth == 0) {
      return ctx.failure('single-newline stop disabled');
    }
    final buf = ctx.buffer;
    final pos = ctx.position;
    if (pos >= buf.length) return ctx.failure('end of input');
    final c = buf.codeUnitAt(pos);
    if (c == 0x0a || c == 0x0d) return ctx.success(null, pos);
    return ctx.failure('not a newline');
  }

  @override
  int fastParseOn(String buf, int pos) {
    if (grammar._singleNewlineDepth == 0) return -1;
    if (pos >= buf.length) return -1;
    final c = buf.codeUnitAt(pos);
    if (c == 0x0a || c == 0x0d) return pos;
    return -1;
  }

  @override
  Parser<void> copy() => _SingleNewlineIfFlagParser(grammar);
}

// Port of e621ng/dtext's inline text scanner (the `text` rule in ragel's
// full `inline` machine): a single text run, ending at the first char that
// could open another inline element. Stops divide into always-stop (`\n`
// `\r` `[` `` ` ``) and conditional-stop (`"` `<` `{` `\\` h/H, plus any
// alpha) that fire only when the bytes that follow can actually start
// markup. In merging contexts the splits are invisible; in table cells and
// textile titles they preserve byte-for-byte parity with the reference.
class _TextRunParser extends Parser<DTextInline> {
  _TextRunParser();

  static bool _startsHttp(String buf, int pos) {
    if (pos + 4 > buf.length) return false;
    return (buf.codeUnitAt(pos) | 0x20) == 0x68 &&
        (buf.codeUnitAt(pos + 1) | 0x20) == 0x74 &&
        (buf.codeUnitAt(pos + 2) | 0x20) == 0x74 &&
        (buf.codeUnitAt(pos + 3) | 0x20) == 0x70;
  }

  static bool _looksLikeTextileTitle(String buf, int pos) {
    final len = buf.length;
    var i = pos + 1;
    while (i < len) {
      final c = buf.codeUnitAt(i);
      if (c == 0x22) {
        if (i == pos + 1) return false;
        return i + 1 < len && buf.codeUnitAt(i + 1) == 0x3a;
      }
      if (c == 0x0a || c == 0x0d) return false;
      i++;
    }
    return false;
  }

  int _scan(String buf, int start) {
    final len = buf.length;
    var i = start;
    while (i < len) {
      final c = buf.codeUnitAt(i);
      if (c == 0x0a || c == 0x0d || c == 0x5b || c == 0x60) break;
      if (c == 0x5c && i + 1 < len && buf.codeUnitAt(i + 1) == 0x60) break;
      if (c == 0x22) {
        if (_startsHttp(buf, i + 1) || _looksLikeTextileTitle(buf, i)) break;
      } else if (c == 0x3c) {
        if (_startsHttp(buf, i + 1)) break;
      } else if (c == 0x7b) {
        if (i + 1 < len && buf.codeUnitAt(i + 1) == 0x7b) break;
      } else if (c == 0x68 || c == 0x48) {
        if (_startsHttp(buf, i)) break;
      }
      // e621ng/dtext's text scanner also stops at any ASCII alpha that
      // opens an id-link prefix and where the id-link pattern actually
      // matches at this position. The bitmap check is the cheap filter;
      // the regex peek (which has the `\b` boundary) is the commit
      // gate.
      if (c < 128 &&
          DTextGrammar._idLinkStartCodes[c] &&
          DTextGrammar._idLinkInTextRegex.matchAsPrefix(buf, i) != null) {
        break;
      }
      i++;
    }
    return i;
  }

  @override
  Result<DTextInline> parseOn(Context context) {
    final buf = context.buffer;
    final start = context.position;
    final end = _scan(buf, start);
    if (end == start) return context.failure('text run expected');
    return context.success(DTextText(buf.substring(start, end)), end);
  }

  @override
  int fastParseOn(String buf, int pos) {
    final end = _scan(buf, pos);
    return end == pos ? -1 : end;
  }

  @override
  Parser<DTextInline> copy() => _TextRunParser();
}

class _MagicIdLinkParser extends Parser<DTextInline> {
  @override
  Result<DTextInline> parseOn(Context context) {
    final buf = context.buffer;
    final pos = context.position;
    if (pos >= buf.length) return context.failure('id-link expected');
    final c = buf.codeUnitAt(pos);
    if (c >= 128 || !DTextGrammar._idLinkStartCodes[c]) {
      return context.failure('id-link expected');
    }
    final match = DTextGrammar._idLinkInTextRegex.matchAsPrefix(buf, pos);
    if (match == null) return context.failure('id-link expected');
    final type = DTextGrammar._idTypeFromPrefix(match.group(1)!);
    final id = match.group(2)!;
    return context.success(
      DTextLink(
        linkType: DTextLinkType.idLink,
        idType: type,
        id: id,
        href: '${DTextGrammar._idRoutes[type]!}$id',
        children: [DTextText('${DTextGrammar._idDisplay[type]!} #$id')],
      ),
      match.end,
    );
  }

  @override
  int fastParseOn(String buffer, int position) {
    if (position >= buffer.length) return -1;
    final c = buffer.codeUnitAt(position);
    if (c >= 128 || !DTextGrammar._idLinkStartCodes[c]) return -1;
    final match = DTextGrammar._idLinkInTextRegex.matchAsPrefix(
      buffer,
      position,
    );
    return match?.end ?? -1;
  }

  @override
  Parser<DTextInline> copy() => _MagicIdLinkParser();
}

// Scans one list-item line: returns characters up to `\n` / `\r` or the
// first `[/?(code|quote|section|table|ltable)]` lookahead, whichever
// comes first. Inline scan keeps the per-char fast path off the parser
// machinery; the rare `[` triggers a manual tag match.
class _ListLineParser extends Parser<String> {
  static const List<String> _stopTags = [
    'code',
    'quote',
    'section',
    'table',
    'ltable',
  ];

  static bool _matchesIgnoreCase(String buf, int pos, String tag) {
    if (pos + tag.length > buf.length) return false;
    for (var i = 0; i < tag.length; i++) {
      final c = buf.codeUnitAt(pos + i);
      final t = tag.codeUnitAt(i);
      // ASCII case-fold: tags are all lowercase letters.
      if (c != t && (c | 0x20) != t) return false;
    }
    return true;
  }

  static bool _isStopAt(String buf, int pos) {
    var p = pos + 1;
    if (p >= buf.length) return false;
    if (buf.codeUnitAt(p) == 0x2f) {
      p++;
      if (p >= buf.length) return false;
    }
    for (final tag in _stopTags) {
      if (_matchesIgnoreCase(buf, p, tag)) {
        final after = p + tag.length;
        if (after < buf.length && buf.codeUnitAt(after) == 0x5d) {
          return true;
        }
      }
    }
    return false;
  }

  // When the cursor sits on `[[`, jump past the matching `]]` on the same
  // line so the inner `[code]/[table]/[ltable]` literal does not trip the
  // stop scanner and strand the rest of the list item. Returns the index
  // just past `]]`, or -1 if no close is found on this line.
  static int _wikiLinkEnd(String buf, int pos, int len) {
    if (pos + 1 >= len || buf.codeUnitAt(pos + 1) != 0x5b) return -1;
    for (var j = pos + 2; j + 1 < len; j++) {
      final c = buf.codeUnitAt(j);
      if (c == 0x0a || c == 0x0d) return -1;
      if (c == 0x5d && buf.codeUnitAt(j + 1) == 0x5d) return j + 2;
    }
    return -1;
  }

  @override
  Result<String> parseOn(Context context) {
    final buf = context.buffer;
    final start = context.position;
    final len = buf.length;
    var i = start;
    while (i < len) {
      final c = buf.codeUnitAt(i);
      if (c == 0x0a || c == 0x0d) break;
      if (c == 0x5b) {
        final wikiEnd = _wikiLinkEnd(buf, i, len);
        if (wikiEnd > 0) {
          i = wikiEnd;
          continue;
        }
        if (_isStopAt(buf, i)) break;
      }
      i++;
    }
    if (i == start) return context.failure('list line char expected');
    return context.success(buf.substring(start, i), i);
  }

  @override
  int fastParseOn(String buf, int position) {
    final len = buf.length;
    var i = position;
    while (i < len) {
      final c = buf.codeUnitAt(i);
      if (c == 0x0a || c == 0x0d) break;
      if (c == 0x5b) {
        final wikiEnd = _wikiLinkEnd(buf, i, len);
        if (wikiEnd > 0) {
          i = wikiEnd;
          continue;
        }
        if (_isStopAt(buf, i)) break;
      }
      i++;
    }
    return i == position ? -1 : i;
  }

  @override
  Parser<String> copy() => _ListLineParser();
}

// First-character dispatch for the block ChoiceParser. The five families
// the document supports have disjoint first-char triggers: headers (`h`/`H`
// + digit + `.`), unordered list (`*`), bracketed-container blocks (`[`).
// Anything else collapses to paragraph (or stray-close as a final fallback).
// Lets the parser skip 3-4 `.and()` peeks on the common `paragraph` branch.
class _BlockDispatchParser extends Parser<DTextBlock> {
  _BlockDispatchParser({
    required this.headerBlock,
    required this.listBlock,
    required this.bracketBlock,
    required this.paragraph,
    required this.strayClose,
  });

  Parser<DTextBlock> headerBlock;
  Parser<DTextBlock> listBlock;
  Parser<Object?> bracketBlock;
  Parser<DTextBlock> paragraph;
  Parser<DTextBlock> strayClose;

  @override
  Result<DTextBlock> parseOn(Context context) {
    final buf = context.buffer;
    final pos = context.position;
    if (pos < buf.length) {
      final c = buf.codeUnitAt(pos);
      if (c == 0x68 || c == 0x48) {
        final r = headerBlock.parseOn(context);
        if (r is Success<DTextBlock>) return r;
      } else if (c == 0x2a) {
        final r = listBlock.parseOn(context);
        if (r is Success<DTextBlock>) return r;
      } else if (c == 0x5b) {
        final r = bracketBlock.parseOn(context);
        if (r is Success<Object?>) {
          return context.success(r.value! as DTextBlock, r.position);
        }
      }
    }
    final p = paragraph.parseOn(context);
    if (p is Success<DTextBlock>) return p;
    return strayClose.parseOn(context);
  }

  @override
  List<Parser> get children => [
    headerBlock,
    listBlock,
    bracketBlock,
    paragraph,
    strayClose,
  ];

  @override
  void replace(Parser source, Parser target) {
    super.replace(source, target);
    if (headerBlock == source) headerBlock = target as Parser<DTextBlock>;
    if (listBlock == source) listBlock = target as Parser<DTextBlock>;
    if (bracketBlock == source) bracketBlock = target as Parser<Object?>;
    if (paragraph == source) paragraph = target as Parser<DTextBlock>;
    if (strayClose == source) strayClose = target as Parser<DTextBlock>;
  }

  @override
  Parser<DTextBlock> copy() => _BlockDispatchParser(
    headerBlock: headerBlock,
    listBlock: listBlock,
    bracketBlock: bracketBlock,
    paragraph: paragraph,
    strayClose: strayClose,
  );
}

// Matches `\n` or `\r\n` without flattening: the consumed bytes are
// discarded so the parser allocates nothing per match. Used everywhere
// `_blockSeparator()` appears inside a `.star()` / `.plusSeparated()`.
class _NewlineParser extends Parser<void> {
  @override
  Result<void> parseOn(Context context) {
    final buf = context.buffer;
    final len = buf.length;
    var p = context.position;
    if (p >= len) return context.failure('newline expected');
    if (buf.codeUnitAt(p) == 0x0d) {
      p++;
      if (p >= len) return context.failure('newline expected');
    }
    if (buf.codeUnitAt(p) != 0x0a) {
      return context.failure('newline expected');
    }
    return context.success(null, p + 1);
  }

  @override
  int fastParseOn(String buffer, int position) {
    final len = buffer.length;
    var p = position;
    if (p >= len) return -1;
    if (buffer.codeUnitAt(p) == 0x0d) {
      p++;
      if (p >= len) return -1;
    }
    if (buffer.codeUnitAt(p) != 0x0a) return -1;
    return p + 1;
  }

  @override
  Parser<void> copy() => _NewlineParser();
}

// Succeeds at column 0: either pos 0 or the preceding char is `\n`.
// Mirrors e621ng/dtext's "at line start" check (ruby precondition for
// block markers) so the inline container can break on a list/header
// marker after the blank-line eater has already swallowed the leading
// `\n`s.
class _AtLineStartParser extends Parser<void> {
  @override
  Result<void> parseOn(Context context) {
    final pos = context.position;
    if (pos == 0 || context.buffer.codeUnitAt(pos - 1) == 0x0a) {
      return context.success(null);
    }
    return context.failure('not at line start');
  }

  @override
  int fastParseOn(String buffer, int pos) {
    if (pos == 0 || buffer.codeUnitAt(pos - 1) == 0x0a) return pos;
    return -1;
  }

  @override
  Parser<void> copy() => _AtLineStartParser();
}
