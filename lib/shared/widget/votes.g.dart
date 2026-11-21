// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'votes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VoteResult _$VoteResultFromJson(Map<String, dynamic> json) => _VoteResult(
  score: (json['score'] as num).toInt(),
  ourScore: (json['our_score'] as num).toInt(),
);

Map<String, dynamic> _$VoteResultToJson(_VoteResult instance) =>
    <String, dynamic>{'score': instance.score, 'our_score': instance.ourScore};
