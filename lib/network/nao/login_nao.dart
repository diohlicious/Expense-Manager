/*

import 'package:meta/meta.dart';

import '../network_config.dart';
import '../network_endpoints.dart';

/// Login Network Access Object Class -> Network Access Object class for handling network requests of Login process
class LoginNAO {

  /// STATIC Is Authentic User Method -> Future<UserModel>
  /// @param -> @required userName -> String
  ///        -> @required userPassword -> String
  /// @usage -> Makes a HTTP-POST request to REST api on server.
  static Future<UserModel> isAuthenticUser(
  {@required String userName, @required String userPassword}) =>
      NetworkUtil().post( // HTTP-POST request
          url: NetworkEndpoints.LOGIN_API, // REST api URL
          body: { // Request body
            NetworkConfig.API_KEY_USER_NAME: userName,
            NetworkConfig.API_KEY_USER_PASSWORD: userPassword
          }).then((dynamic response) { // On response received
            print(response);
            return UserModel.fromJson(response);// Map json response to UserModel object
          });
}

class NetworkUtil {
  post({String url, Map<String, String> body}) {}
}
*/
