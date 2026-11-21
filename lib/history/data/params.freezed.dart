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
mixin _$HistoryParams implements DiagnosticableTreeMixin {

 DateTime? get date; String? get link; String? get title; String? get subtitle; Set<HistoryCategory>? get categories; Set<HistoryType>? get types;
/// Create a copy of HistoryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryParamsCopyWith<HistoryParams> get copyWith => _$HistoryParamsCopyWithImpl<HistoryParams>(this as HistoryParams, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'HistoryParams'))
    ..add(DiagnosticsProperty('date', date))..add(DiagnosticsProperty('link', link))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('subtitle', subtitle))..add(DiagnosticsProperty('categories', categories))..add(DiagnosticsProperty('types', types));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryParams&&(identical(other.date, date) || other.date == date)&&(identical(other.link, link) || other.link == link)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.types, types));
}


@override
int get hashCode => Object.hash(runtimeType,date,link,title,subtitle,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(types));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'HistoryParams(date: $date, link: $link, title: $title, subtitle: $subtitle, categories: $categories, types: $types)';
}


}

/// @nodoc
abstract mixin class $HistoryParamsCopyWith<$Res>  {
  factory $HistoryParamsCopyWith(HistoryParams value, $Res Function(HistoryParams) _then) = _$HistoryParamsCopyWithImpl;
@useResult
$Res call({
 DateTime? date, String? link, String? title, String? subtitle, Set<HistoryCategory>? categories, Set<HistoryType>? types
});




}
/// @nodoc
class _$HistoryParamsCopyWithImpl<$Res>
    implements $HistoryParamsCopyWith<$Res> {
  _$HistoryParamsCopyWithImpl(this._self, this._then);

  final HistoryParams _self;
  final $Res Function(HistoryParams) _then;

/// Create a copy of HistoryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = freezed,Object? link = freezed,Object? title = freezed,Object? subtitle = freezed,Object? categories = freezed,Object? types = freezed,}) {
  return _then(_self.copyWith(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Set<HistoryCategory>?,types: freezed == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as Set<HistoryType>?,
  ));
}

}



/// @nodoc


class _HistoryParams extends HistoryParams with DiagnosticableTreeMixin {
  const _HistoryParams({this.date, this.link, this.title, this.subtitle, final  Set<HistoryCategory>? categories, final  Set<HistoryType>? types}): _categories = categories,_types = types,super._();
  

@override final  DateTime? date;
@override final  String? link;
@override final  String? title;
@override final  String? subtitle;
 final  Set<HistoryCategory>? _categories;
@override Set<HistoryCategory>? get categories {
  final value = _categories;
  if (value == null) return null;
  if (_categories is EqualUnmodifiableSetView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}

 final  Set<HistoryType>? _types;
@override Set<HistoryType>? get types {
  final value = _types;
  if (value == null) return null;
  if (_types is EqualUnmodifiableSetView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}


/// Create a copy of HistoryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryParamsCopyWith<_HistoryParams> get copyWith => __$HistoryParamsCopyWithImpl<_HistoryParams>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'HistoryParams'))
    ..add(DiagnosticsProperty('date', date))..add(DiagnosticsProperty('link', link))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('subtitle', subtitle))..add(DiagnosticsProperty('categories', categories))..add(DiagnosticsProperty('types', types));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryParams&&(identical(other.date, date) || other.date == date)&&(identical(other.link, link) || other.link == link)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._types, _types));
}


@override
int get hashCode => Object.hash(runtimeType,date,link,title,subtitle,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_types));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'HistoryParams(date: $date, link: $link, title: $title, subtitle: $subtitle, categories: $categories, types: $types)';
}


}

/// @nodoc
abstract mixin class _$HistoryParamsCopyWith<$Res> implements $HistoryParamsCopyWith<$Res> {
  factory _$HistoryParamsCopyWith(_HistoryParams value, $Res Function(_HistoryParams) _then) = __$HistoryParamsCopyWithImpl;
@override @useResult
$Res call({
 DateTime? date, String? link, String? title, String? subtitle, Set<HistoryCategory>? categories, Set<HistoryType>? types
});




}
/// @nodoc
class __$HistoryParamsCopyWithImpl<$Res>
    implements _$HistoryParamsCopyWith<$Res> {
  __$HistoryParamsCopyWithImpl(this._self, this._then);

  final _HistoryParams _self;
  final $Res Function(_HistoryParams) _then;

/// Create a copy of HistoryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? link = freezed,Object? title = freezed,Object? subtitle = freezed,Object? categories = freezed,Object? types = freezed,}) {
  return _then(_HistoryParams(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Set<HistoryCategory>?,types: freezed == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as Set<HistoryType>?,
  ));
}


}

// dart format on
