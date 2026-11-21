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
mixin _$FollowParams implements DiagnosticableTreeMixin {

 String? get tags; String? get title; List<FollowType>? get types; bool? get hasUnseen;
/// Create a copy of FollowParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowParamsCopyWith<FollowParams> get copyWith => _$FollowParamsCopyWithImpl<FollowParams>(this as FollowParams, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FollowParams'))
    ..add(DiagnosticsProperty('tags', tags))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('types', types))..add(DiagnosticsProperty('hasUnseen', hasUnseen));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowParams&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.types, types)&&(identical(other.hasUnseen, hasUnseen) || other.hasUnseen == hasUnseen));
}


@override
int get hashCode => Object.hash(runtimeType,tags,title,const DeepCollectionEquality().hash(types),hasUnseen);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FollowParams(tags: $tags, title: $title, types: $types, hasUnseen: $hasUnseen)';
}


}

/// @nodoc
abstract mixin class $FollowParamsCopyWith<$Res>  {
  factory $FollowParamsCopyWith(FollowParams value, $Res Function(FollowParams) _then) = _$FollowParamsCopyWithImpl;
@useResult
$Res call({
 String? tags, String? title, List<FollowType>? types, bool? hasUnseen
});




}
/// @nodoc
class _$FollowParamsCopyWithImpl<$Res>
    implements $FollowParamsCopyWith<$Res> {
  _$FollowParamsCopyWithImpl(this._self, this._then);

  final FollowParams _self;
  final $Res Function(FollowParams) _then;

/// Create a copy of FollowParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tags = freezed,Object? title = freezed,Object? types = freezed,Object? hasUnseen = freezed,}) {
  return _then(_self.copyWith(
tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,types: freezed == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as List<FollowType>?,hasUnseen: freezed == hasUnseen ? _self.hasUnseen : hasUnseen // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}



/// @nodoc


class _FollowParams extends FollowParams with DiagnosticableTreeMixin {
  const _FollowParams({this.tags, this.title, final  List<FollowType>? types, this.hasUnseen}): _types = types,super._();
  

@override final  String? tags;
@override final  String? title;
 final  List<FollowType>? _types;
@override List<FollowType>? get types {
  final value = _types;
  if (value == null) return null;
  if (_types is EqualUnmodifiableListView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? hasUnseen;

/// Create a copy of FollowParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowParamsCopyWith<_FollowParams> get copyWith => __$FollowParamsCopyWithImpl<_FollowParams>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FollowParams'))
    ..add(DiagnosticsProperty('tags', tags))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('types', types))..add(DiagnosticsProperty('hasUnseen', hasUnseen));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowParams&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._types, _types)&&(identical(other.hasUnseen, hasUnseen) || other.hasUnseen == hasUnseen));
}


@override
int get hashCode => Object.hash(runtimeType,tags,title,const DeepCollectionEquality().hash(_types),hasUnseen);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FollowParams(tags: $tags, title: $title, types: $types, hasUnseen: $hasUnseen)';
}


}

/// @nodoc
abstract mixin class _$FollowParamsCopyWith<$Res> implements $FollowParamsCopyWith<$Res> {
  factory _$FollowParamsCopyWith(_FollowParams value, $Res Function(_FollowParams) _then) = __$FollowParamsCopyWithImpl;
@override @useResult
$Res call({
 String? tags, String? title, List<FollowType>? types, bool? hasUnseen
});




}
/// @nodoc
class __$FollowParamsCopyWithImpl<$Res>
    implements _$FollowParamsCopyWith<$Res> {
  __$FollowParamsCopyWithImpl(this._self, this._then);

  final _FollowParams _self;
  final $Res Function(_FollowParams) _then;

/// Create a copy of FollowParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tags = freezed,Object? title = freezed,Object? types = freezed,Object? hasUnseen = freezed,}) {
  return _then(_FollowParams(
tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,types: freezed == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as List<FollowType>?,hasUnseen: freezed == hasUnseen ? _self.hasUnseen : hasUnseen // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
