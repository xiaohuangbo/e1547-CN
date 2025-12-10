// ignore_for_file: avoid_print

import 'package:e1547/markup/markup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petitparser/debug.dart';
import 'package:petitparser/petitparser.dart';

class LabeledDTextGrammar extends DTextGrammar {
  @override
  Parser<DTextElement> links() => super.links().labeled('links');

  @override
  Parser<DTextElement> link() => super.link().labeled('link');

  @override
  Parser<DTextElement> linkWord() => super.linkWord().labeled('linkWord');

  @override
  Parser<DTextElement> localLink() => super.localLink().labeled('localLink');

  @override
  Parser<DTextElement> tagLink() => super.tagLink().labeled('tagLink');

  @override
  Parser<DTextElement> tagSearchLink() =>
      super.tagSearchLink().labeled('tagSearchLink');

  @override
  Parser<DTextElement> structures() => super.structures().labeled('structures');

  @override
  Parser<DTextElement> blocks() => super.blocks().labeled('blocks');

  @override
  Parser<DTextElement> header() => super.header().labeled('header');

  @override
  Parser<DTextElement> quote() => super.quote().labeled('quote');

  @override
  Parser<DTextElement> section() => super.section().labeled('section');

  @override
  Parser<DTextElement> spoiler() => super.spoiler().labeled('spoiler');

  @override
  Parser<DTextElement> code() => super.code().labeled('code');

  @override
  Parser<DTextElement> list() => super.list().labeled('list');

  @override
  Parser<DTextElement> styles() => super.styles().labeled('styles');

  @override
  Parser<DTextElement> inlineStyles() =>
      super.inlineStyles().labeled('inlineStyles');

  @override
  Parser<DTextElement> bold() => super.bold().labeled('bold');

  @override
  Parser<DTextElement> italic() => super.italic().labeled('italic');

  @override
  Parser<DTextElement> inlineCode() => super.inlineCode().labeled('inlineCode');

  @override
  Parser<DTextElement> textElement() =>
      super.textElement().labeled('textElement');

  @override
  Parser<DTextElement> character() => super.character().labeled('character');
}

String generateLargeDTextContent() {
  final segments = [
    'This is a paragraph with some text and post #12345 references.',
    'Here we have [[wiki links]] and "textile links":https://example.com',
    'h1. Header Level 1\n\nSome content under the header.',
    'h2. Header Level 2\n\nMore content here.',
    '* List item one with thumb #67890',
    '* List item two with comment #555',
    '** Nested list item',
    '[quote]This is a quoted section with user #999[/quote]',
    '[code]some code here[/code]',
    '{{post search with multiple words}}',
    '[spoiler]Hidden content here[/spoiler]',
    'Regular text with artist #123 and pool #456 references.',
    'More text with [b]bold[/b] and [i]italic[/i] formatting.',
    'Links like https://example.com and http://test.org',
    'Email addresses like test@example.com',
    'Tag searches like [[howto:tag]] and [[category:example]]',
  ];

  final buffer = StringBuffer();
  const repetitions = 500;

  for (int i = 0; i < repetitions; i++) {
    for (final segment in segments) {
      buffer.write('$segment\n\n');
    }

    buffer.write('h3. Section ${i + 1}\n\n');
    buffer.write(
      'This is section ${i + 1} with [[post #${1000 + i}]] and [[user #${2000 + i}]].\n\n',
    );
  }

  return buffer.toString();
}

void main() {
  group('DText Parser Profiling', () {
    test('should output timing information for each grammar method', () {
      final testContent = generateLargeDTextContent();

      print('Profiling DText parser with ${testContent.length} characters');

      final grammar = LabeledDTextGrammar();
      final parser = grammar.build();

      final List<ProfileFrame> labeledFrames = [];
      final profilingParser = profile(
        parser,
        output: labeledFrames.add,
        predicate: (parser) => parser is LabeledParser,
      );

      final stopwatch = Stopwatch()..start();
      final result = profilingParser.parse(testContent);
      stopwatch.stop();

      final totalTime = stopwatch.elapsed;

      print('\nTotal parse time: ${totalTime.inMilliseconds}ms');

      labeledFrames.sort((a, b) => b.elapsed.compareTo(a.elapsed));

      print('\nGrammar method timings:');
      for (final frame in labeledFrames) {
        final labeledParser = frame.parser as LabeledParser;
        final percentage =
            (frame.elapsed.inMicroseconds / totalTime.inMicroseconds) * 100;
        final avgTime = frame.count > 0
            ? frame.elapsed.inMicroseconds / frame.count / 1000
            : 0;
        print(
          '  ${labeledParser.label.padRight(30)} ${frame.elapsed.inMilliseconds.toString().padLeft(8)}.${(frame.elapsed.inMicroseconds % 1000).toString().padLeft(2, '0')}ms (${percentage.toStringAsFixed(1).padLeft(5)}%) - ${frame.count.toString().padRight(8)} calls - ${avgTime.toStringAsFixed(3)}ms avg',
        );
      }

      expect(result, isA<Success>());
    });
  });
}
