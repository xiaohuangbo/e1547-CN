// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'votes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoteResult {

 int get score; int get ourScore;
/// Create a copy of VoteResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoteResultCopyWith<VoteResult> get copyWith => _$VoteResultCopyWithImpl<VoteResult>(this as VoteResult, _$identity);

  /// Serializes this VoteResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoteResult&&(identical(other.score, score) || other.score == score)&&(identical(other.ourScore, ourScore) || other.ourScore == ourScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,ourScore);

@override
String toString() {
  return 'VoteResult(score: $score, ourScore: $ourScore)';
}


}

/// @nodoc
abstract mixin class $VoteResultCopyWith<$Res>  {
  factory $VoteResultCopyWith(VoteResult value, $Res Function(VoteResult) _then) = _$VoteResultCopyWithImpl;
@useResult
$Res call({
 int score, int ourScore
});




}
/// @nodoc
class _$VoteResultCopyWithImpl<$Res>
    implements $VoteResultCopyWith<$Res> {
  _$VoteResultCopyWithImpl(this._self, this._then);

  final VoteResult _self;
  final $Res Function(VoteResult) _then;

/// Create a copy of VoteResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? ourScore = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,ourScore: null == ourScore ? _self.ourScore : ourScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _VoteResult implements VoteResult {
  const _VoteResult({required this.score, required this.ourScore});
  factory _VoteResult.fromJson(Map<String, dynamic> json) => _$VoteResultFromJson(json);

@override final  int score;
@override final  int ourScore;

/// Create a copy of VoteResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoteResultCopyWith<_VoteResult> get copyWith => __$VoteResultCopyWithImpl<_VoteResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoteResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoteResult&&(identical(other.score, score) || other.score == score)&&(identical(other.ourScore, ourScore) || other.ourScore == ourScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,ourScore);

@override
String toString() {
  return 'VoteResult(score: $score, ourScore: $ourScore)';
}


}

/// @nodoc
abstract mixin class _$VoteResultCopyWith<$Res> implements $VoteResultCopyWith<$Res> {
  factory _$VoteResultCopyWith(_VoteResult value, $Res Function(_VoteResult) _then) = __$VoteResultCopyWithImpl;
@override @useResult
$Res call({
 int score, int ourScore
});




}
/// @nodoc
class __$VoteResultCopyWithImpl<$Res>
    implements _$VoteResultCopyWith<$Res> {
  __$VoteResultCopyWithImpl(this._self, this._then);

  final _VoteResult _self;
  final $Res Function(_VoteResult) _then;

/// Create a copy of VoteResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? ourScore = null,}) {
  return _then(_VoteResult(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,ourScore: null == ourScore ? _self.ourScore : ourScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
