// Conformance test runner.
//
// Each per-category test file (`blocks_test.dart`, `inline_test.dart`, ...)
// is a thin wrapper that calls [runFixtures] with its category name. The
// runner loads `fixtures/<category>.json`, iterates entries, and asserts
// that the Dart parser's canonical JSON output equals the frozen expected.
//
// This file survives commit 2. It does NOT depend on `_bridge/`, `_compare/`,
// or `_bench/` so plain `flutter test test/markup/conformance/` works after
// the dev harness is deleted.

import 'dart:convert';
import 'dart:io';

import 'package:e1547/markup/data/grammar.dart';
import 'package:flutter_test/flutter_test.dart';

import 'canonical.dart';

/// A frozen conformance fixture.
class ConformanceFixture {
  ConformanceFixture({
    required this.label,
    required this.input,
    required this.expected,
    required this.skip,
  });

  factory ConformanceFixture.fromJson(Map<String, dynamic> json) =>
      ConformanceFixture(
        label: json['label'] as String,
        input: json['input'] as String,
        expected: json['expected'],
        skip: json['skip'] as String?,
      );

  /// Human-readable identifier shown in test output.
  final String label;

  /// The dtext source the parser will receive.
  final String input;

  /// The canonical AST tree (Map / List / scalar) the parser must produce,
  /// frozen at corpus distillation time from the dmark proxy oracle's
  /// `parseDTextToAST`. May be `null` for entries that have not been
  /// regenerated yet; such entries fail loudly so the corpus author is
  /// forced to run regenerate.sh.
  final Object? expected;

  /// If non-null, the test is marked skipped with this reason. Used to pin
  /// known divergences so the test surfaces both as a doc of the bug and a
  /// signal when the underlying bug is fixed.
  final String? skip;
}

List<ConformanceFixture> loadFixtures(String category) {
  final path = _resolveFixturePath(category);
  final raw = File(path).readAsStringSync();
  final list = json.decode(raw) as List;
  return [
    for (final e in list)
      ConformanceFixture.fromJson(e as Map<String, dynamic>),
  ];
}

/// Standard runner: registers one `test()` per fixture under a top-level
/// `group(category)`. Assertion is canonical-JSON byte equality between the
/// Dart parser's `toJson()` output and the frozen expected tree.
void runFixtures(String category) {
  final fixtures = loadFixtures(category);
  group(category, () {
    for (final f in fixtures) {
      test(f.label, () {
        if (f.expected == null) {
          fail(
            'fixture "${f.label}" in $category.json has no frozen expected '
            'value; run test/markup/regenerate.sh to populate it',
          );
        }
        final ast = _parseToJson(f.input);
        final expectedJson = canonicalize(f.expected);
        final actualJson = canonicalize(ast);
        if (actualJson != expectedJson) {
          fail(
            'AST mismatch for "${f.label}"\n'
            '  input:    ${json.encode(f.input)}\n'
            '  expected: $expectedJson\n'
            '  actual:   $actualJson',
          );
        }
      }, skip: f.skip);
    }
  });
}

final _grammar = DTextGrammar();

/// Single indirection in front of the grammar entry point so that any
/// future rename touches one line. Returns a JSON-style tree (Map / List /
/// scalar) suitable for direct comparison against the frozen expected
/// output (captured from dmark at corpus distillation time).
Object? _parseToJson(String input) => _grammar.parse(input).toJson();

String _resolveFixturePath(String category) {
  const rel = 'test/markup/conformance/fixtures';
  var dir = Directory.current;
  for (var i = 0; i < 6; i++) {
    final p = '${dir.path}/$rel/$category.json';
    if (File(p).existsSync()) return p;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  throw StateError(
    'fixture file $category.json not found under $rel '
    '(searched up from ${Directory.current.path})',
  );
}
