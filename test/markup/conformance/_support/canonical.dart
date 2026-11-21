// Canonical JSON for AST comparison.
//
// Both this parser and the dmark proxy oracle emit the same AST shape but
// cannot be relied on to insert map keys in the same order. Canonical
// encoding here means: recursive alpha-sort of object keys, lists preserved
// positionally, and a compact one-line representation so byte-for-byte
// string equality is a safe equivalence check.
//
// Parse-failure note: when dmark cannot parse a fragment its oracle pipeline
// may emit an HTML fallback rather than a tree of AST nodes. Those cases
// are stripped from the strict corpus rather than translated, and land in a
// separate "graceful failure" suite that only asserts this parser did not
// crash and produced a renderable AST. So `canonicalize` here does NOT need
// a fallback rewriter.

import 'dart:convert';

/// Deeply alpha-sorts map keys and returns a normalized tree.
///
/// Numeric types are preserved (`int` vs `double` differences in the source
/// AST are surfaced as diffs; we don't paper over them). Strings, bools,
/// and nulls pass through.
Object? canonicalTree(Object? node) {
  if (node is Map) {
    final sortedKeys = node.keys.map((k) => k.toString()).toList()..sort();
    return {for (final k in sortedKeys) k: canonicalTree(node[k])};
  }
  if (node is List) {
    return [for (final item in node) canonicalTree(item)];
  }
  return node;
}

/// Canonical compact JSON string. Use for direct equality assertions.
String canonicalize(Object? node) => json.encode(canonicalTree(node));

/// Canonical pretty-printed JSON. Use when writing frozen expected fixtures
/// or printing a failing diff so a human can read it.
String canonicalizePretty(Object? node) =>
    const JsonEncoder.withIndent('  ').convert(canonicalTree(node));
