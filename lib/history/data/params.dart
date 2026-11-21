import 'package:e1547/history/history.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'params.freezed.dart';

@freezed
abstract class HistoryParams with _$HistoryParams {
  const factory HistoryParams({
    DateTime? date,
    String? link,
    String? title,
    String? subtitle,
    Set<HistoryCategory>? categories,
    Set<HistoryType>? types,
  }) = _HistoryParams;

  const HistoryParams._();

  factory HistoryParams.fromQuery(QueryMap? query) {
    if (query == null) return const HistoryParams();
    DateTime? date;
    final dateStr = query['search[date]'];
    if (dateStr != null) {
      try {
        date = _dateFormat.parse(dateStr);
      } on FormatException {
        date = null;
      }
    }
    return HistoryParams(
      date: date,
      link: query['search[link]'],
      title: query['search[title]'],
      subtitle: query['search[subtitle]'],
      categories: _parseEnumSet(
        query['search[category]'],
        HistoryCategory.values,
      ),
      types: _parseEnumSet(query['search[type]'], HistoryType.values),
    );
  }

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  QueryMap toQuery() => <String, Object?>{
    'search[date]': date != null ? _dateFormat.format(date!) : null,
    'search[link]': link,
    'search[title]': title,
    'search[subtitle]': subtitle,
    'search[category]': categories?.map((e) => e.name).toList(),
    'search[type]': types?.map((e) => e.name).toList(),
  }.toQuery();
}

Set<E>? _parseEnumSet<E extends Enum>(String? value, List<E> values) {
  if (value == null || value.isEmpty) return null;
  final byName = values.asNameMap();
  final result = <E>{for (final v in value.split(',')) ?byName[v.trim()]};
  return result.isEmpty ? null : result;
}

class HistoryParamsController extends ValueNotifier<HistoryParams> {
  HistoryParamsController([HistoryParams? initial])
    : super(initial ?? const HistoryParams());

  void update(HistoryParams Function(HistoryParams) updater) =>
      value = updater(value);
}
