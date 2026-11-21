import 'dart:convert';

import 'package:e1547/markup/markup.dart';

/// Serialise [value] to JSON with alpha-sorted object keys and no extra
/// whitespace, so the result matches dmark's parser output byte-for-byte
/// after dmark is run through the same canonicalisation.
String canonicalJson(Object? value) {
  final buffer = StringBuffer();
  _writeCanonical(buffer, value);
  return buffer.toString();
}

void _writeCanonical(StringBuffer buffer, Object? value) {
  if (value == null) {
    buffer.write('null');
  } else if (value is bool) {
    buffer.write(value ? 'true' : 'false');
  } else if (value is num) {
    buffer.write(value);
  } else if (value is String) {
    buffer.write(jsonEncode(value));
  } else if (value is DTextNode) {
    _writeCanonical(buffer, value.toJson());
  } else if (value is List) {
    buffer.write('[');
    for (var i = 0; i < value.length; i++) {
      if (i > 0) buffer.write(',');
      _writeCanonical(buffer, value[i]);
    }
    buffer.write(']');
  } else if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    buffer.write('{');
    for (var i = 0; i < keys.length; i++) {
      if (i > 0) buffer.write(',');
      buffer
        ..write(jsonEncode(keys[i]))
        ..write(':');
      _writeCanonical(buffer, value[keys[i]]);
    }
    buffer.write('}');
  } else {
    throw ArgumentError(
      'cannot canonicalise value of type ${value.runtimeType}',
    );
  }
}
