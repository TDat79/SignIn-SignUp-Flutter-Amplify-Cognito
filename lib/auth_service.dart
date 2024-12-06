import 'package:amplify_flutter/amplify_flutter.dart';

class AuthService {
  /// Đăng ký tài khoản
  Future<void> signUp(String email, String password) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: {
          AuthUserAttributeKey.email: email,  // Sử dụng AuthUserAttributeKey.email
        }),
      );
      print('Sign up successful: ${result.isSignUpComplete}');
    } catch (e) {
      print('Sign up failed: $e');
    }
  }

  /// Xác thực OTP
  Future<void> confirmSignUp(String email, String confirmationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
      print('OTP confirmed: ${result.isSignUpComplete}');
    } catch (e) {
      print('OTP confirmation failed: $e');
    }
  }

  /// Đăng nhập
  Future<bool> signIn(String email, String password) async {
    try {
      await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      print('Sign in successful');
      return true;
    } catch (e) {
      print('Sign in failed: $e');
      return false;
    }
  }

}
