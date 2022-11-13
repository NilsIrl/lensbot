import 'package:fl_lens/profile.dart';
import 'package:graphql/client.dart';
import 'dart:js';

class Networking {
  static const apilink = "https://api-mumbai.lens.dev/";
  // static List<ProfileMetaData> getProfiles() {
  //   return [];
  // }

  static Future<String> getDefaultProfile(String addr) {
    final link = HttpLink(apilink);
    final client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );

    final query = gql('''
      query DefaultProfile {
        defaultProfile(request: { ethereumAddress: "$addr"}) {
          id
        }
      }
      ''');

    final result = client.query(QueryOptions(document: query));

    return result.then((value) => value.data!['defaultProfile']['id']);
  }

  static void publish(String jwt, String profile, String uri) async {
    final link = HttpLink(uri, defaultHeaders: {
      'x-access-token': jwt,
    });
    final client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );

    final mutation = gql('''
      mutation CreatePostTypedData {
        createPostTypedData(request: {
          profileId: "$profile",
          contentURI: "$uri",
          collectModule: {
            revertCollectModule: true
          },
          referenceModule: {
            followerOnlyReferenceModule: false
          }
        }) {
          id
          expiresAt
          typedData {
            types {
              PostWithSig {
                name
                type
              }
            }
            domain {
              name
              chainId
              version
              verifyingContract
            }
            value {
              nonce
              deadline
              profileId
              contentURI
              collectModule
              collectModuleInitData
              referenceModule
              referenceModuleInitData
            }
          }
        }
      }
      ''');

    final result = await client
        .mutate(MutationOptions(document: mutation))
        .then((value) => value.data!);
    final typedData = result['createPostTypedData']['typedData'];
    final id = await result['createPostTypedData']['id'];
    final signedTypedData = await context.callMethod('getTypedSignature',
        [typedData['domain'], typedData['types'], typedData['value']]);

    final mutation2 = gql(r'''
      mutation Broadcast($request: BroadcastRequest!) {
              broadcast(request: $request) {
                  ... on RelayerResult {
                      txHash
              txId
                  }
                  ... on RelayError {
                      reason
                  }
              }
          }
    ''');

    final result2 =
        await client.mutate(MutationOptions(document: mutation2, variables: {
      'request': {
        'id': id,
        'signature': signedTypedData,
      }
    }));

    print(result2);
  }

  static Future<String> getLoginToken(String addr) {
    final link = HttpLink(apilink);
    final client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );

    final query = gql('''
      query Challenge {
        challenge(request: { address: "$addr" }) {
          text
        }
      }
    ''');

    final result = client.query(QueryOptions(
      document: query,
      variables: <String, dynamic>{
        'addr': addr,
      },
    ));
    return result.then((value) => value.data!["challenge"]["text"]);
  }

  static Future<String> getJWT(addr, sig) {
    final link = HttpLink(apilink);
    final client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );

    final query = gql('''
    mutation Authenticate {
  authenticate(request: {
    address: "$addr",
    signature: "$sig"
  }) {
    accessToken
    refreshToken
  }
}
  ''');

    final result = client.query(
      QueryOptions(document: query),
    );

    return result.then((value) => value.data!["authenticate"][
        "accessToken"]); // we could also return address token if we want sessions to last for more than 30 mins
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
      return profile;
    });
  }
}
