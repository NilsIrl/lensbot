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
