// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttributeData _$AttributeDataFromJson(Map<String, dynamic> json) =>
    AttributeData(
      displayType: $enumDecodeNullable(
          _$MetadataDisplayTypeEnumMap, json['displayType']),
      value: json['value'] as String,
      traitType: json['traitType'] as String?,
      key: json['key'] as String,
    );

Map<String, dynamic> _$AttributeDataToJson(AttributeData instance) =>
    <String, dynamic>{
      'displayType': _$MetadataDisplayTypeEnumMap[instance.displayType],
      'traitType': instance.traitType,
      'value': instance.value,
      'key': instance.key,
    };

const _$MetadataDisplayTypeEnumMap = {
  MetadataDisplayType.number: 'number',
  MetadataDisplayType.string: 'string',
  MetadataDisplayType.date: 'date',
};

ProfileMetaData _$ProfileMetaDataFromJson(Map<String, dynamic> json) =>
    ProfileMetaData(
      name: json['name'] as String?,
      metadataId: json['metadata_id'] as String,
      bio: json['bio'] as String?,
      coverPicture: json['cover_picture'] as String?,
      attributes: (json['attributes'] as List<dynamic>)
          .map((e) => AttributeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: $enumDecode(_$MetaDataVersionsEnumMap, json['version']),
    );

Map<String, dynamic> _$ProfileMetaDataToJson(ProfileMetaData instance) =>
    <String, dynamic>{
      'version': _$MetaDataVersionsEnumMap[instance.version]!,
      'metadata_id': instance.metadataId,
      'name': instance.name,
      'bio': instance.bio,
      'cover_picture': instance.coverPicture,
      'attributes': instance.attributes.map((e) => e.toJson()).toList(),
    };

const _$MetaDataVersionsEnumMap = {
  MetaDataVersions.one: 'one',
};
