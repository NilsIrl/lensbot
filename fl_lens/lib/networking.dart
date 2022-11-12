import 'package:fl_lens/profile.dart';
import 'package:graphql/client.dart';

class Networking {
  static const apilink = "https://api-mumbai.lens.dev/";
  static List<ProfileMetaData> getProfiles() {
    return [];
  }

  static Future<ProfileMetaData?>? getProfileFromId(String id) {
    final link = HttpLink(apilink);
    final client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
    final query = gql('''
      query Profile {
  profile(request: { profileId: "$id" }) {
    id
    name
    bio
    attributes {
      displayType
      traitType
      key
      value
    }
    followNftAddress
    metadata
    isDefault
    picture {
      ... on NftImage {
        contractAddress
        tokenId
        uri
        verified
      }
      ... on MediaSet {
        original {
          url
          mimeType
        }
      }
    }
    handle
    coverPicture {
      ... on NftImage {
        contractAddress
        tokenId
        uri
        verified
      }
      ... on MediaSet {
        original {
          url
          mimeType
        }
      }
    }
    ownedBy
    dispatcher {
      address
      canUseRelay
    }
    stats {
      totalFollowers
      totalFollowing
      totalPosts
      totalComments
      totalMirrors
      totalPublications
      totalCollects
    }
    followModule {
      ... on FeeFollowModuleSettings {
        type
        amount {
          asset {
            symbol
            name
            decimals
            address
          }
          value
        }
        recipient
      }
      ... on ProfileFollowModuleSettings {
        type
      }
      ... on RevertFollowModuleSettings {
        type
      }
    }
  }
}
      ''');
    final result = client.query(
      QueryOptions(
        document: query,
        variables: <String, dynamic>{
          'id': id,
        },
      ),
    );

    return result.then((value) {
      final data = value.data!;
      final profile = ProfileMetaData.fromJson(data['profile']);
      print(profile);
      return profile;
    });
  }
}
