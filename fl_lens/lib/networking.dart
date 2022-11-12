import 'package:fl_lens/profile.dart';
import 'package:graphql/client.dart';

class Networking {
  static const apilink = "https://api-mumbai.lens.dev/";
  static List<ProfileMetaData> getProfiles() {
    return [];
  }

  static Future<ProfileMetaData?> getProfileFromId(String id) {
    final link = HttpLink(apilink);
    final client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
    final query = gql(r'''
      query GetProfile($id: String!) {
        profile(id: $id) {
          id
          name
          bio
          coverPicture
          attributes {
            displayType
            value
            traitType
            key
          }
          version
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
    // result.onError((error, stackTrace) {
    //   print(error);
    //   return result;
    // });
    return result.then((value) {
      final data = value.data;
      final profile = ProfileMetaData.fromJson(data!['profile']);
      return profile;
    });
  }
}
