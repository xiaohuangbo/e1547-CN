import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';

enum CommentGroupBy { post, comment }

enum CommentOrder {
  newest('id_desc'),
  oldest('id_asc');

  const CommentOrder(this.value);

  final String value;
}

@freezed
abstract class CommentParams with _$CommentParams {
  const factory CommentParams({
    @Default(CommentGroupBy.post) CommentGroupBy groupBy,
    int? postId,
    String? body,
    String? creator,
    List<String>? postTags,
    @Default(CommentOrder.newest) CommentOrder order,
  }) = _CommentParams;

  const CommentParams._();

  QueryMap toQuery() => <String, Object?>{
    if (groupBy != CommentGroupBy.post) 'group_by': groupBy,
    'search[post_id]': postId,
    'search[body_matches]': body,
    'search[creator_name]': creator,
    'search[post_tags_match]': postTags?.join(' '),
    if (order != CommentOrder.newest) 'search[order]': order.value,
  }.toQuery();
}

class CommentParamsController extends ValueNotifier<CommentParams> {
  CommentParamsController([CommentParams? initial])
    : super(initial ?? const CommentParams());

  void update(CommentParams Function(CommentParams) updater) =>
      value = updater(value);
}
