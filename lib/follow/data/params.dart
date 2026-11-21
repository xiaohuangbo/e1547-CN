import 'package:e1547/follow/follow.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';

@freezed
abstract class FollowParams with _$FollowParams {
  const factory FollowParams({
    String? tags,
    String? title,
    List<FollowType>? types,
    bool? hasUnseen,
  }) = _FollowParams;

  const FollowParams._();

  QueryMap toQuery() => <String, Object?>{
    'search[tags]': tags,
    'search[title]': title,
    'search[type]': types?.map((e) => e.name).toList(),
    'search[has_unseen]': hasUnseen,
  }.toQuery();
}

class FollowParamsController extends ValueNotifier<FollowParams> {
  FollowParamsController([FollowParams? initial])
    : super(initial ?? const FollowParams());

  void update(FollowParams Function(FollowParams) updater) =>
      value = updater(value);
}
