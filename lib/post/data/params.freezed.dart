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
mixin _$PostParams implements DiagnosticableTreeMixin {

 String? get tags;
/// Create a copy of PostParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostParamsCopyWith<PostParams> get copyWith => _$PostParamsCopyWithImpl<PostParams>(this as PostParams, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PostParams'))
    ..add(DiagnosticsProperty('tags', tags));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostParams&&(identical(other.tags, tags) || other.tags == tags));
}


@override
int get hashCode => Object.hash(runtimeType,tags);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PostParams(tags: $tags)';
}


}

/// @nodoc
abstract mixin class $PostParamsCopyWith<$Res>  {
  factory $PostParamsCopyWith(PostParams value, $Res Function(PostParams) _then) = _$PostParamsCopyWithImpl;
@useResult
$Res call({
 String? tags
});




}
/// @nodoc
class _$PostParamsCopyWithImpl<$Res>
    implements $PostParamsCopyWith<$Res> {
  _$PostParamsCopyWithImpl(this._self, this._then);

  final PostParams _self;
  final $Res Function(PostParams) _then;

/// Create a copy of PostParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tags = freezed,}) {
  return _then(_self.copyWith(
tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc


class _PostParams extends PostParams with DiagnosticableTreeMixin {
  const _PostParams({this.tags}): super._();
  

@override final  String? tags;

/// Create a copy of PostParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostParamsCopyWith<_PostParams> get copyWith => __$PostParamsCopyWithImpl<_PostParams>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PostParams'))
    ..add(DiagnosticsProperty('tags', tags));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostParams&&(identical(other.tags, tags) || other.tags == tags));
}


@override
int get hashCode => Object.hash(runtimeType,tags);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PostParams(tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$PostParamsCopyWith<$Res> implements $PostParamsCopyWith<$Res> {
  factory _$PostParamsCopyWith(_PostParams value, $Res Function(_PostParams) _then) = __$PostParamsCopyWithImpl;
@override @useResult
$Res call({
 String? tags
});




}
/// @nodoc
class __$PostParamsCopyWithImpl<$Res>
    implements _$PostParamsCopyWith<$Res> {
  __$PostParamsCopyWithImpl(this._self, this._then);

  final _PostParams _self;
  final $Res Function(_PostParams) _then;

/// Create a copy of PostParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tags = freezed,}) {
  return _then(_PostParams(
tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
