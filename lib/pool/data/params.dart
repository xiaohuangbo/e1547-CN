import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';

enum PoolCategory { series, collection }

enum PoolOrder {
  name('name'),
  createdAt('created_at'),
  updatedAt('updated_at'),
  postCount('post_count');

  const PoolOrder(this.value);

  final String value;
}

@freezed
abstract class PoolParams with _$PoolParams {
  const factory PoolParams({
    String? name,
    String? description,
    String? creator,
    bool? active,
    PoolCategory? category,
    PoolOrder? order,
  }) = _PoolParams;

  const PoolParams._();

  factory PoolParams.fromQuery(QueryMap? query) {
    if (query == null) return const PoolParams();
    final activeStr = query['search[is_active]'];
    bool? active;
    if (activeStr == 'true') {
      active = true;
    } else if (activeStr == 'false') {
      active = false;
    }
    final categoryStr = query['search[category]'];
    final orderStr = query['search[order]'];
    return PoolParams(
      name: query['search[name_matches]'],
      description: query['search[description_matches]'],
      creator: query['search[creator_name]'],
      active: active,
      category: PoolCategory.values.asNameMap()[categoryStr ?? ''],
      order: PoolOrder.values.where((o) => o.value == orderStr).firstOrNull,
    );
  }

  QueryMap toQuery() => <String, Object?>{
    'search[name_matches]': name,
    'search[description_matches]': description,
    'search[creator_name]': creator,
    'search[is_active]': active == null ? null : (active! ? 'true' : 'false'),
    'search[category]': category?.name,
    'search[order]': order?.value,
  }.toQuery();
}

class PoolParamsController extends ValueNotifier<PoolParams> {
  PoolParamsController([PoolParams? initial])
    : super(initial ?? const PoolParams());

  void update(PoolParams Function(PoolParams) updater) =>
      value = updater(value);
}
