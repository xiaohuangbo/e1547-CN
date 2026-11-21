import 'dart:convert';
import 'dart:io';

/// Stands in for the server address in recorded asset urls, so a test server
/// can rewrite it to whatever port it bound.
const String fixtureHost = '{{host}}';

/// Loads a recorded API response from `test/_fixtures`.
Object? loadFixture(String name) =>
    jsonDecode(File('test/_fixtures/$name').readAsStringSync());

List<Map<String, Object?>> loadFixtureList(String name) =>
    (loadFixture(name)! as List).cast<Map<String, Object?>>();
