// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonEnum()
enum MetadataDisplayType { number, string, date }

@JsonEnum()
enum MetaDataVersions {
  @JsonKey(name: "1.0.0")
  one
}

@JsonSerializable()
class AttributeData {
  const AttributeData({
    required this.displayType,
    required this.value,
    required this.traitType,
    required this.key,
  });

  final MetadataDisplayType? displayType;
  final String? traitType;
  final String value;
  final String key;

  factory AttributeData.fromJson(Map<String, dynamic> json) => _$AttributeDataFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeDataToJson(this);
}

@JsonSerializable()
class ProfileMetaData {

  ProfileMetaData();

  final MetaDataVersions version;
  final String metadata_id;
  final String? name;
  

  factory ProfileMetaData.fromJson(Map<String, dynamic> json) => _$ProfileMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileMetaDataToJson(this);
}


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
