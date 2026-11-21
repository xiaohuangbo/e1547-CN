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
mixin _$TopicParams implements DiagnosticableTreeMixin {

 String? get title; TopicCategory? get category; TopicOrder get order; bool? get sticky; bool? get locked;
/// Create a copy of TopicParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicParamsCopyWith<TopicParams> get copyWith => _$TopicParamsCopyWithImpl<TopicParams>(this as TopicParams, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TopicParams'))
    ..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('category', category))..add(DiagnosticsProperty('order', order))..add(DiagnosticsProperty('sticky', sticky))..add(DiagnosticsProperty('locked', locked));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicParams&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.order, order) || other.order == order)&&(identical(other.sticky, sticky) || other.sticky == sticky)&&(identical(other.locked, locked) || other.locked == locked));
}


@override
int get hashCode => Object.hash(runtimeType,title,category,order,sticky,locked);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TopicParams(title: $title, category: $category, order: $order, sticky: $sticky, locked: $locked)';
}


}

/// @nodoc
abstract mixin class $TopicParamsCopyWith<$Res>  {
  factory $TopicParamsCopyWith(TopicParams value, $Res Function(TopicParams) _then) = _$TopicParamsCopyWithImpl;
@useResult
$Res call({
 String? title, TopicCategory? category, TopicOrder order, bool? sticky, bool? locked
});




}
/// @nodoc
class _$TopicParamsCopyWithImpl<$Res>
    implements $TopicParamsCopyWith<$Res> {
  _$TopicParamsCopyWithImpl(this._self, this._then);

  final TopicParams _self;
  final $Res Function(TopicParams) _then;

/// Create a copy of TopicParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? category = freezed,Object? order = null,Object? sticky = freezed,Object? locked = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TopicCategory?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as TopicOrder,sticky: freezed == sticky ? _self.sticky : sticky // ignore: cast_nullable_to_non_nullable
as bool?,locked: freezed == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}



/// @nodoc


class _TopicParams extends TopicParams with DiagnosticableTreeMixin {
  const _TopicParams({this.title, this.category, this.order = TopicOrder.sticky, this.sticky, this.locked}): super._();
  

@override final  String? title;
@override final  TopicCategory? category;
@override@JsonKey() final  TopicOrder order;
@override final  bool? sticky;
@override final  bool? locked;

/// Create a copy of TopicParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicParamsCopyWith<_TopicParams> get copyWith => __$TopicParamsCopyWithImpl<_TopicParams>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TopicParams'))
    ..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('category', category))..add(DiagnosticsProperty('order', order))..add(DiagnosticsProperty('sticky', sticky))..add(DiagnosticsProperty('locked', locked));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicParams&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.order, order) || other.order == order)&&(identical(other.sticky, sticky) || other.sticky == sticky)&&(identical(other.locked, locked) || other.locked == locked));
}


@override
int get hashCode => Object.hash(runtimeType,title,category,order,sticky,locked);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TopicParams(title: $title, category: $category, order: $order, sticky: $sticky, locked: $locked)';
}


}

/// @nodoc
abstract mixin class _$TopicParamsCopyWith<$Res> implements $TopicParamsCopyWith<$Res> {
  factory _$TopicParamsCopyWith(_TopicParams value, $Res Function(_TopicParams) _then) = __$TopicParamsCopyWithImpl;
@override @useResult
$Res call({
 String? title, TopicCategory? category, TopicOrder order, bool? sticky, bool? locked
});




}
/// @nodoc
class __$TopicParamsCopyWithImpl<$Res>
    implements _$TopicParamsCopyWith<$Res> {
  __$TopicParamsCopyWithImpl(this._self, this._then);

  final _TopicParams _self;
  final $Res Function(_TopicParams) _then;

/// Create a copy of TopicParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? category = freezed,Object? order = null,Object? sticky = freezed,Object? locked = freezed,}) {
  return _then(_TopicParams(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TopicCategory?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as TopicOrder,sticky: freezed == sticky ? _self.sticky : sticky // ignore: cast_nullable_to_non_nullable
as bool?,locked: freezed == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
