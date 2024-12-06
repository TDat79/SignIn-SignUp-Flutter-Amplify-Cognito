import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class CognitoService {
  final String _userPoolId = 'ap-southeast-1_Jq0jCG4LT';
  final String _clientId = '5hi4divvr326p8krfk4fto4a6u';

  late final CognitoUserPool _userPool;

  CognitoService() {
    _userPool = CognitoUserPool(_userPoolId, _clientId);
  }

  Future<String?> signUp(String username, String password, String email) async {
    try {
      final userAttributes = [
        AttributeArg(name: 'email', value: email),
      ];
      var data = await _userPool.signUp(username, password, userAttributes: userAttributes);
      return data.userSub;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  Future<CognitoUserSession?> signIn(String username, String password) async {
    final cognitoUser = CognitoUser(username, _userPool);
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    try {
      return await cognitoUser.authenticateUser(authDetails);
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  Future<void> signOut(String username) async {
    final cognitoUser = CognitoUser(username, _userPool);
    try {
      return await cognitoUser.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }
}