import 'package:meta/meta.dart';

@immutable
sealed class DTextNode {
  const DTextNode();

  String get type;

  Map<String, Object?> toJson();
}

@immutable
sealed class DTextBlock extends DTextNode {
  const DTextBlock();
}

@immutable
sealed class DTextInline extends DTextNode {
  const DTextInline();
}

@immutable
sealed class DTextTableChild extends DTextNode {
  const DTextTableChild();
}

final class DTextDocument extends DTextNode {
  const DTextDocument(this.children);

  final List<DTextBlock> children;

  @override
  String get type => 'document';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextHeader extends DTextBlock {
  const DTextHeader({required this.level, required this.children});

  final int level;
  final List<DTextInline> children;

  @override
  String get type => 'header';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'level': level,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextParagraph extends DTextBlock {
  const DTextParagraph(this.children);

  final List<DTextInline> children;

  @override
  String get type => 'paragraph';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextQuote extends DTextBlock {
  const DTextQuote({required this.children, this.color});

  final List<DTextBlock> children;
  final String? color;

  @override
  String get type => 'quote';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
    if (color != null) 'color': color,
  };
}

final class DTextSpoilerBlock extends DTextBlock {
  const DTextSpoilerBlock(this.children);

  final List<DTextBlock> children;

  @override
  String get type => 'spoiler_block';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextSection extends DTextBlock {
  const DTextSection({required this.children, this.title, this.expanded});

  final List<DTextBlock> children;
  final String? title;
  final bool? expanded;

  @override
  String get type => 'section';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
    if (title != null) 'title': title,
    if (expanded != null) 'expanded': expanded,
  };
}

final class DTextCodeBlock extends DTextBlock {
  const DTextCodeBlock(this.content);

  final String content;

  @override
  String get type => 'code_block';

  @override
  Map<String, Object?> toJson() => {'type': type, 'content': content};
}

final class DTextRawBlockText extends DTextBlock {
  const DTextRawBlockText(this.content);

  final String content;

  @override
  String get type => 'raw_block_text';

  @override
  Map<String, Object?> toJson() => {'type': type, 'content': content};
}

final class DTextLiteralHtml extends DTextBlock {
  const DTextLiteralHtml({required this.prefix, required this.children});

  final String prefix;
  final List<DTextInline> children;

  @override
  String get type => 'literal_html';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'prefix': prefix,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextTable extends DTextBlock {
  const DTextTable(this.children);

  final List<DTextTableChild> children;

  @override
  String get type => 'table';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextLTable extends DTextBlock {
  const DTextLTable({required this.children, this.source});

  final List<DTextTableChild> children;
  final String? source;

  @override
  String get type => 'ltable';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
    if (source != null) 'source': source,
  };
}

final class DTextList extends DTextBlock {
  const DTextList(this.items);

  final List<DTextListItem> items;

  @override
  String get type => 'list';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'items': items.map((e) => e.toJson()).toList(),
  };
}

@immutable
final class DTextListItem extends DTextNode {
  const DTextListItem({required this.depth, required this.children});

  final int depth;
  final List<DTextInline> children;

  @override
  String get type => 'list_item';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'depth': depth,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextTableHead extends DTextTableChild {
  const DTextTableHead(this.rows);

  final List<DTextTableChild> rows;

  @override
  String get type => 'table_head';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'rows': rows.map((e) => e.toJson()).toList(),
  };
}

final class DTextTableBody extends DTextTableChild {
  const DTextTableBody(this.rows);

  final List<DTextTableChild> rows;

  @override
  String get type => 'table_body';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'rows': rows.map((e) => e.toJson()).toList(),
  };
}

final class DTextTableRow extends DTextTableChild {
  const DTextTableRow(this.cells);

  final List<DTextTableCell> cells;

  @override
  String get type => 'table_row';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'cells': cells.map((e) => e.toJson()).toList(),
  };
}

final class DTextTableLiteral extends DTextTableChild {
  const DTextTableLiteral(this.content);

  final String content;

  @override
  String get type => 'table_literal';

  @override
  Map<String, Object?> toJson() => {'type': type, 'content': content};
}

enum DTextTableCellType {
  th,
  td;

  String get jsonValue => name;
}

@immutable
final class DTextTableCell extends DTextNode {
  const DTextTableCell({required this.cellType, required this.children});

  final DTextTableCellType cellType;
  final List<DTextInline> children;

  @override
  String get type => 'table_cell';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'cellType': cellType.jsonValue,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextText extends DTextInline {
  const DTextText(this.content);

  final String content;

  @override
  String get type => 'text';

  @override
  Map<String, Object?> toJson() => {'type': type, 'content': content};
}

final class DTextBold extends DTextInline {
  const DTextBold(this.children);

  final List<DTextInline> children;

  @override
  String get type => 'bold';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextItalic extends DTextInline {
  const DTextItalic(this.children);

  final List<DTextInline> children;

  @override
  String get type => 'italic';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextStrikeout extends DTextInline {
  const DTextStrikeout(this.children);

  final List<DTextInline> children;

  @override
  String get type => 'strikeout';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextUnderline extends DTextInline {
  const DTextUnderline(this.children);

  final List<DTextInline> children;

  @override
  String get type => 'underline';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextSuperscript extends DTextInline {
  const DTextSuperscript(this.children);

  final List<DTextInline> children;

  @override
  String get type => 'superscript';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextSubscript extends DTextInline {
  const DTextSubscript(this.children);

  final List<DTextInline> children;

  @override
  String get type => 'subscript';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextInlineSpoiler extends DTextInline {
  const DTextInlineSpoiler(this.children);

  final List<DTextInline> children;

  @override
  String get type => 'inline_spoiler';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextInlineCode extends DTextInline {
  const DTextInlineCode(this.content);

  final String content;

  @override
  String get type => 'inline_code';

  @override
  Map<String, Object?> toJson() => {'type': type, 'content': content};
}

final class DTextColor extends DTextInline {
  const DTextColor({required this.color, required this.children});

  final String color;
  final List<DTextInline> children;

  @override
  String get type => 'color';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'color': color,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

final class DTextInternalAnchor extends DTextInline {
  const DTextInternalAnchor(this.name);

  final String name;

  @override
  String get type => 'internal_anchor';

  @override
  Map<String, Object?> toJson() => {'type': type, 'name': name};
}

final class DTextLineBreak extends DTextInline {
  const DTextLineBreak();

  @override
  String get type => 'line_break';

  @override
  Map<String, Object?> toJson() => {'type': type};
}

enum DTextFragmentWrapper {
  sub,
  sup;

  String get jsonValue => name;
}

final class DTextFragment extends DTextInline {
  const DTextFragment({required this.children, this.wrapper});

  final List<DTextInline> children;
  final DTextFragmentWrapper? wrapper;

  @override
  String get type => 'fragment';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'children': children.map((e) => e.toJson()).toList(),
    if (wrapper != null) 'wrapper': wrapper!.jsonValue,
  };
}

enum DTextLinkType {
  url('url'),
  inline('inline'),
  wiki('wiki'),
  postSearch('post_search'),
  idLink('id_link');

  const DTextLinkType(this.jsonValue);

  final String jsonValue;
}

enum DTextIdType {
  post('post'),
  thumb('thumb'),
  postChanges('post_changes'),
  flag('flag'),
  note('note'),
  forumPost('forum_post'),
  topic('topic'),
  comment('comment'),
  pool('pool'),
  user('user'),
  artist('artist'),
  ban('ban'),
  bur('bur'),
  alias('alias'),
  implication('implication'),
  modAction('mod_action'),
  record('record'),
  wiki('wiki'),
  set('set'),
  blip('blip'),
  takedown('takedown'),
  ticket('ticket');

  const DTextIdType(this.jsonValue);

  final String jsonValue;
}

final class DTextLink extends DTextInline {
  const DTextLink({
    required this.linkType,
    required this.href,
    this.title,
    this.children,
    this.idType,
    this.id,
    this.anchor,
    this.tags,
  });

  final DTextLinkType linkType;
  final String href;
  final String? title;
  final List<DTextInline>? children;
  final DTextIdType? idType;
  final String? id;
  final String? anchor;
  final String? tags;

  @override
  String get type => 'link';

  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'linkType': linkType.jsonValue,
    'href': href,
    if (title != null) 'title': title,
    if (children != null) 'children': children!.map((e) => e.toJson()).toList(),
    if (idType != null) 'idType': idType!.jsonValue,
    if (id != null) 'id': id,
    if (anchor != null) 'anchor': anchor,
    if (tags != null) 'tags': tags,
  };
}
