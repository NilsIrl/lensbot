// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vrouter/vrouter.dart';
import 'networking.dart';
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

  @override
  String toString() {
    return 'AttributeData(displayType: $displayType, traitType: $traitType, value: $value, key: $key)';
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileMetaData {

  ProfileMetaData({
    required this.name,
    this.metadataId,
    required this.bio,
    this.coverPicture,
    required this.attributes,
    this.version,
    this.picture,
  });

  final MetaDataVersions? version;
  final String ?metadataId;
  final String? name;
  final String? bio;
  final String? coverPicture;
  final ProfilePicture? picture;
  final List<AttributeData> attributes; // TODO: for bots, we will know in advance that there will be just one attribute (the bot's contract)

  factory ProfileMetaData.fromJson(Map<String, dynamic> json) => _$ProfileMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileMetaDataToJson(this);

  @override
  String toString() {
    return 'ProfileMetaData(version: $version, metadataId: $metadataId, name: $name, bio: $bio, coverPicture: $coverPicture, picture: $picture, attributes: $attributes)';
    }
}

@JsonSerializable()
class Picture {
  const Picture({
    required this.url,
    required this.mimeType,
  });

  final String? url;
  final String? mimeType;

  factory Picture.fromJson(Map<String, dynamic> json) => _$PictureFromJson(json);

  Map<String, dynamic> toJson() => _$PictureToJson(this);

  @override
  String toString() {
    return 'Picture(url: $url, mimeType: $mimeType)';
  }
}

@JsonSerializable()
class ProfilePicture {
  const ProfilePicture({
    required this.original,
  });

  final Picture? original;

  factory ProfilePicture.fromJson(Map<String, dynamic> json) => _$ProfilePictureFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePictureToJson(this);

  @override
  String toString() {
    return 'ProfilePicture(original: $original)';
  }
}



class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final params = VRouter.of(context).pathParameters;
    final id = params['id'];
    final profile = Networking.getProfileFromId(id!);
    return ProfileFutureCard(profile: profile);
  }
}

class ProfileFutureCard extends StatelessWidget {
  const ProfileFutureCard({
    super.key,
    required this.profile,
  });

  final Future<ProfileMetaData?>? profile;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: profile,
      builder: (context, future) {
        if (future.hasData) {
          final profile = future.data;
          if (profile == null) {
            return const Text("Profile not found");
          }
          return Row(
          children: [
            Column(
              children: [
                Text(profile.name ?? 'No name'),
                Text(profile.bio ?? 'No bio'),
              ],
            ),
            Image.network(profile.picture?.original?.url ?? ''),
          ],
        );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
