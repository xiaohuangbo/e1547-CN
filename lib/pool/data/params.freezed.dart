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
mixin _$PoolParams implements DiagnosticableTreeMixin {

 String? get name; String? get description; String? get creator; bool? get active; PoolCategory? get category; PoolOrder? get order;
/// Create a copy of PoolParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoolParamsCopyWith<PoolParams> get copyWith => _$PoolParamsCopyWithImpl<PoolParams>(this as PoolParams, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PoolParams'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('creator', creator))..add(DiagnosticsProperty('active', active))..add(DiagnosticsProperty('category', category))..add(DiagnosticsProperty('order', order));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoolParams&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.active, active) || other.active == active)&&(identical(other.category, category) || other.category == category)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,creator,active,category,order);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PoolParams(name: $name, description: $description, creator: $creator, active: $active, category: $category, order: $order)';
}


}

/// @nodoc
abstract mixin class $PoolParamsCopyWith<$Res>  {
  factory $PoolParamsCopyWith(PoolParams value, $Res Function(PoolParams) _then) = _$PoolParamsCopyWithImpl;
@useResult
$Res call({
 String? name, String? description, String? creator, bool? active, PoolCategory? category, PoolOrder? order
});




}
/// @nodoc
class _$PoolParamsCopyWithImpl<$Res>
    implements $PoolParamsCopyWith<$Res> {
  _$PoolParamsCopyWithImpl(this._self, this._then);

  final PoolParams _self;
  final $Res Function(PoolParams) _then;

/// Create a copy of PoolParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? description = freezed,Object? creator = freezed,Object? active = freezed,Object? category = freezed,Object? order = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PoolCategory?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PoolOrder?,
  ));
}

}



/// @nodoc


class _PoolParams extends PoolParams with DiagnosticableTreeMixin {
  const _PoolParams({this.name, this.description, this.creator, this.active, this.category, this.order}): super._();
  

@override final  String? name;
@override final  String? description;
@override final  String? creator;
@override final  bool? active;
@override final  PoolCategory? category;
@override final  PoolOrder? order;

/// Create a copy of PoolParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoolParamsCopyWith<_PoolParams> get copyWith => __$PoolParamsCopyWithImpl<_PoolParams>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PoolParams'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('creator', creator))..add(DiagnosticsProperty('active', active))..add(DiagnosticsProperty('category', category))..add(DiagnosticsProperty('order', order));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoolParams&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.active, active) || other.active == active)&&(identical(other.category, category) || other.category == category)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,creator,active,category,order);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PoolParams(name: $name, description: $description, creator: $creator, active: $active, category: $category, order: $order)';
}


}

/// @nodoc
abstract mixin class _$PoolParamsCopyWith<$Res> implements $PoolParamsCopyWith<$Res> {
  factory _$PoolParamsCopyWith(_PoolParams value, $Res Function(_PoolParams) _then) = __$PoolParamsCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? description, String? creator, bool? active, PoolCategory? category, PoolOrder? order
});




}
/// @nodoc
class __$PoolParamsCopyWithImpl<$Res>
    implements _$PoolParamsCopyWith<$Res> {
  __$PoolParamsCopyWithImpl(this._self, this._then);

  final _PoolParams _self;
  final $Res Function(_PoolParams) _then;

/// Create a copy of PoolParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? description = freezed,Object? creator = freezed,Object? active = freezed,Object? category = freezed,Object? order = freezed,}) {
  return _then(_PoolParams(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PoolCategory?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PoolOrder?,
  ));
}


}

// dart format on
