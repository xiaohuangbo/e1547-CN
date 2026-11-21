// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskMetadata _$TaskMetadataFromJson(Map<String, dynamic> json) =>
    _TaskMetadata(
      previewUrl: json['preview_url'] as String?,
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
    );

Map<String, dynamic> _$TaskMetadataToJson(_TaskMetadata instance) =>
    <String, dynamic>{
      'preview_url': instance.previewUrl,
      'file_url': instance.fileUrl,
      'file_name': instance.fileName,
    };
