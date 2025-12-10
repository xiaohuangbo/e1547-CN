// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TagPreview _$TagPreviewFromJson(Map<String, dynamic> json) => _TagPreview(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  category: (json['category'] as num?)?.toInt(),
  postCount: (json['post_count'] as num?)?.toInt(),
  implies: (json['implies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  alias: json['alias'] as String?,
  resolved: json['resolved'] as String?,
);

Map<String, dynamic> _$TagPreviewToJson(_TagPreview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'post_count': instance.postCount,
      'implies': instance.implies,
      'alias': instance.alias,
      'resolved': instance.resolved,
    };
