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
      metadataId: json['metadata_id'] as String?,
      bio: json['bio'] as String?,
      coverPicture: json['cover_picture'] as String?,
      attributes: (json['attributes'] as List<dynamic>)
          .map((e) => AttributeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: $enumDecodeNullable(_$MetaDataVersionsEnumMap, json['version']),
      picture: json['picture'] == null
          ? null
          : ProfilePicture.fromJson(json['picture'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileMetaDataToJson(ProfileMetaData instance) =>
    <String, dynamic>{
      'version': _$MetaDataVersionsEnumMap[instance.version],
      'metadata_id': instance.metadataId,
      'name': instance.name,
      'bio': instance.bio,
      'cover_picture': instance.coverPicture,
      'picture': instance.picture?.toJson(),
      'attributes': instance.attributes.map((e) => e.toJson()).toList(),
    };

const _$MetaDataVersionsEnumMap = {
  MetaDataVersions.one: 'one',
};

Picture _$PictureFromJson(Map<String, dynamic> json) => Picture(
      url: json['url'] as String?,
      mimeType: json['mimeType'] as String?,
    );

Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'url': instance.url,
      'mimeType': instance.mimeType,
    };

ProfilePicture _$ProfilePictureFromJson(Map<String, dynamic> json) =>
    ProfilePicture(
      original: json['original'] == null
          ? null
          : Picture.fromJson(json['original'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfilePictureToJson(ProfilePicture instance) =>
    <String, dynamic>{
      'original': instance.original?.toJson(),
    };
