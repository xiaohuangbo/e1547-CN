// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReplyParams implements DiagnosticableTreeMixin {

 int? get topicId; String? get body; String? get creator; ReplyOrder get order;
/// Create a copy of ReplyParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplyParamsCopyWith<ReplyParams> get copyWith => _$ReplyParamsCopyWithImpl<ReplyParams>(this as ReplyParams, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReplyParams'))
    ..add(DiagnosticsProperty('topicId', topicId))..add(DiagnosticsProperty('body', body))..add(DiagnosticsProperty('creator', creator))..add(DiagnosticsProperty('order', order));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplyParams&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.body, body) || other.body == body)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,topicId,body,creator,order);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReplyParams(topicId: $topicId, body: $body, creator: $creator, order: $order)';
}


}

/// @nodoc
abstract mixin class $ReplyParamsCopyWith<$Res>  {
  factory $ReplyParamsCopyWith(ReplyParams value, $Res Function(ReplyParams) _then) = _$ReplyParamsCopyWithImpl;
@useResult
$Res call({
 int? topicId, String? body, String? creator, ReplyOrder order
});




}
/// @nodoc
class _$ReplyParamsCopyWithImpl<$Res>
    implements $ReplyParamsCopyWith<$Res> {
  _$ReplyParamsCopyWithImpl(this._self, this._then);

  final ReplyParams _self;
  final $Res Function(ReplyParams) _then;

/// Create a copy of ReplyParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topicId = freezed,Object? body = freezed,Object? creator = freezed,Object? order = null,}) {
  return _then(_self.copyWith(
topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as ReplyOrder,
  ));
}

}



/// @nodoc


class _ReplyParams extends ReplyParams with DiagnosticableTreeMixin {
  const _ReplyParams({this.topicId, this.body, this.creator, this.order = ReplyOrder.oldest}): super._();
  

@override final  int? topicId;
@override final  String? body;
@override final  String? creator;
@override@JsonKey() final  ReplyOrder order;

/// Create a copy of ReplyParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplyParamsCopyWith<_ReplyParams> get copyWith => __$ReplyParamsCopyWithImpl<_ReplyParams>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReplyParams'))
    ..add(DiagnosticsProperty('topicId', topicId))..add(DiagnosticsProperty('body', body))..add(DiagnosticsProperty('creator', creator))..add(DiagnosticsProperty('order', order));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplyParams&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.body, body) || other.body == body)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,topicId,body,creator,order);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReplyParams(topicId: $topicId, body: $body, creator: $creator, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ReplyParamsCopyWith<$Res> implements $ReplyParamsCopyWith<$Res> {
  factory _$ReplyParamsCopyWith(_ReplyParams value, $Res Function(_ReplyParams) _then) = __$ReplyParamsCopyWithImpl;
@override @useResult
$Res call({
 int? topicId, String? body, String? creator, ReplyOrder order
});




}
/// @nodoc
class __$ReplyParamsCopyWithImpl<$Res>
    implements _$ReplyParamsCopyWith<$Res> {
  __$ReplyParamsCopyWithImpl(this._self, this._then);

  final _ReplyParams _self;
  final $Res Function(_ReplyParams) _then;

/// Create a copy of ReplyParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topicId = freezed,Object? body = freezed,Object? creator = freezed,Object? order = null,}) {
  return _then(_ReplyParams(
topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as ReplyOrder,
  ));
}


}

// dart format on
