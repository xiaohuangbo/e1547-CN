// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  avatarId: (json['avatar_id'] as num?)?.toInt(),
  hasCroppedAvatar: json['has_cropped_avatar'] as bool? ?? false,
  blacklistedTags: json['blacklisted_tags'] as String?,
  perPage: (json['per_page'] as num?)?.toInt(),
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar_id': instance.avatarId,
  'has_cropped_avatar': instance.hasCroppedAvatar,
  'blacklisted_tags': instance.blacklistedTags,
  'per_page': instance.perPage,
};
