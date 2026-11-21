import 'package:e1547/markup/markup.dart';
import 'package:flutter_test/flutter_test.dart';

import '../_support/canonical_json.dart';

void main() {
  group('canonicalJson', () {
    test('serialises a leaf text node', () {
      const node = DTextText('hello');
      expect(canonicalJson(node), '{"content":"hello","type":"text"}');
    });

    test('alpha-sorts object keys', () {
      const node = DTextHeader(level: 2, children: [DTextText('hi')]);
      expect(
        canonicalJson(node),
        '{"children":[{"content":"hi","type":"text"}],"level":2,"type":"header"}',
      );
    });

    test('omits optional fields when not set', () {
      const node = DTextQuote(
        children: [
          DTextParagraph([DTextText('a')]),
        ],
      );
      final json = canonicalJson(node);
      expect(json.contains('"color"'), isFalse);
    });

    test('includes optional color when set', () {
      const node = DTextQuote(
        children: [
          DTextParagraph([DTextText('a')]),
        ],
        color: 'red',
      );
      final json = canonicalJson(node);
      expect(json.contains('"color":"red"'), isTrue);
    });

    test('escapes strings the same as JSON.stringify', () {
      const node = DTextText('a\nb\\c"d');
      expect(canonicalJson(node), r'{"content":"a\nb\\c\"d","type":"text"}');
    });

    test('round-trips a document', () {
      const doc = DTextDocument([
        DTextHeader(level: 1, children: [DTextText('title')]),
        DTextParagraph([
          DTextText('hello '),
          DTextBold([DTextText('world')]),
        ]),
      ]);
      final json = canonicalJson(doc);
      expect(
        json,
        '{"children":[{"children":[{"content":"title","type":"text"}],"level":1,"type":"header"},{"children":[{"content":"hello ","type":"text"},{"children":[{"content":"world","type":"text"}],"type":"bold"}],"type":"paragraph"}],"type":"document"}',
      );
    });
  });
}
