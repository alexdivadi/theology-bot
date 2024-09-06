// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      profileThumbnail: json['profileThumbnail'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
      'profileThumbnail': instance.profileThumbnail,
      'status': instance.status,
    };
