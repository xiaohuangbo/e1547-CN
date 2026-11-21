import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';

enum ReplyOrder {
  newest('id_desc'),
  oldest('id_asc');

  const ReplyOrder(this.value);

  final String value;
}

@freezed
abstract class ReplyParams with _$ReplyParams {
  const factory ReplyParams({
    int? topicId,
    String? body,
    String? creator,
    @Default(ReplyOrder.oldest) ReplyOrder order,
  }) = _ReplyParams;

  const ReplyParams._();

  QueryMap toQuery() => <String, Object?>{
    'search[topic_id]': topicId,
    'search[body_matches]': body,
    'search[creator_name]': creator,
    'search[order]': order.value,
  }.toQuery();
}

class ReplyParamsController extends ValueNotifier<ReplyParams> {
  ReplyParamsController([ReplyParams? initial])
    : super(initial ?? const ReplyParams());

  void update(ReplyParams Function(ReplyParams) updater) =>
      value = updater(value);
}
