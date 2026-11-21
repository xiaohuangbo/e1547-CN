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
mixin _$CommentParams implements DiagnosticableTreeMixin {

 CommentGroupBy get groupBy; int? get postId; String? get body; String? get creator; List<String>? get postTags; CommentOrder get order;
/// Create a copy of CommentParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentParamsCopyWith<CommentParams> get copyWith => _$CommentParamsCopyWithImpl<CommentParams>(this as CommentParams, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CommentParams'))
    ..add(DiagnosticsProperty('groupBy', groupBy))..add(DiagnosticsProperty('postId', postId))..add(DiagnosticsProperty('body', body))..add(DiagnosticsProperty('creator', creator))..add(DiagnosticsProperty('postTags', postTags))..add(DiagnosticsProperty('order', order));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentParams&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.body, body) || other.body == body)&&(identical(other.creator, creator) || other.creator == creator)&&const DeepCollectionEquality().equals(other.postTags, postTags)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,groupBy,postId,body,creator,const DeepCollectionEquality().hash(postTags),order);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CommentParams(groupBy: $groupBy, postId: $postId, body: $body, creator: $creator, postTags: $postTags, order: $order)';
}


}

/// @nodoc
abstract mixin class $CommentParamsCopyWith<$Res>  {
  factory $CommentParamsCopyWith(CommentParams value, $Res Function(CommentParams) _then) = _$CommentParamsCopyWithImpl;
@useResult
$Res call({
 CommentGroupBy groupBy, int? postId, String? body, String? creator, List<String>? postTags, CommentOrder order
});




}
/// @nodoc
class _$CommentParamsCopyWithImpl<$Res>
    implements $CommentParamsCopyWith<$Res> {
  _$CommentParamsCopyWithImpl(this._self, this._then);

  final CommentParams _self;
  final $Res Function(CommentParams) _then;

/// Create a copy of CommentParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupBy = null,Object? postId = freezed,Object? body = freezed,Object? creator = freezed,Object? postTags = freezed,Object? order = null,}) {
  return _then(_self.copyWith(
groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as CommentGroupBy,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,postTags: freezed == postTags ? _self.postTags : postTags // ignore: cast_nullable_to_non_nullable
as List<String>?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as CommentOrder,
  ));
}

}



/// @nodoc


class _CommentParams extends CommentParams with DiagnosticableTreeMixin {
  const _CommentParams({this.groupBy = CommentGroupBy.post, this.postId, this.body, this.creator, final  List<String>? postTags, this.order = CommentOrder.newest}): _postTags = postTags,super._();
  

@override@JsonKey() final  CommentGroupBy groupBy;
@override final  int? postId;
@override final  String? body;
@override final  String? creator;
 final  List<String>? _postTags;
@override List<String>? get postTags {
  final value = _postTags;
  if (value == null) return null;
  if (_postTags is EqualUnmodifiableListView) return _postTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  CommentOrder order;

/// Create a copy of CommentParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentParamsCopyWith<_CommentParams> get copyWith => __$CommentParamsCopyWithImpl<_CommentParams>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CommentParams'))
    ..add(DiagnosticsProperty('groupBy', groupBy))..add(DiagnosticsProperty('postId', postId))..add(DiagnosticsProperty('body', body))..add(DiagnosticsProperty('creator', creator))..add(DiagnosticsProperty('postTags', postTags))..add(DiagnosticsProperty('order', order));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentParams&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.body, body) || other.body == body)&&(identical(other.creator, creator) || other.creator == creator)&&const DeepCollectionEquality().equals(other._postTags, _postTags)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,groupBy,postId,body,creator,const DeepCollectionEquality().hash(_postTags),order);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CommentParams(groupBy: $groupBy, postId: $postId, body: $body, creator: $creator, postTags: $postTags, order: $order)';
}


}

/// @nodoc
abstract mixin class _$CommentParamsCopyWith<$Res> implements $CommentParamsCopyWith<$Res> {
  factory _$CommentParamsCopyWith(_CommentParams value, $Res Function(_CommentParams) _then) = __$CommentParamsCopyWithImpl;
@override @useResult
$Res call({
 CommentGroupBy groupBy, int? postId, String? body, String? creator, List<String>? postTags, CommentOrder order
});




}
/// @nodoc
class __$CommentParamsCopyWithImpl<$Res>
    implements _$CommentParamsCopyWith<$Res> {
  __$CommentParamsCopyWithImpl(this._self, this._then);

  final _CommentParams _self;
  final $Res Function(_CommentParams) _then;

/// Create a copy of CommentParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupBy = null,Object? postId = freezed,Object? body = freezed,Object? creator = freezed,Object? postTags = freezed,Object? order = null,}) {
  return _then(_CommentParams(
groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as CommentGroupBy,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,postTags: freezed == postTags ? _self._postTags : postTags // ignore: cast_nullable_to_non_nullable
as List<String>?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as CommentOrder,
  ));
}


}

// dart format on
