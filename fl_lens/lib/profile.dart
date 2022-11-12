import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MetaDataDisplayType {
  number, string, date
}

@JsonEnum()
enum MetaDataVersions {
  @JsonKey(name: '1.0.0')
  one
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}