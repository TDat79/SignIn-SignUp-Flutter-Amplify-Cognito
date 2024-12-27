import 'package:amplify_flutter/amplify_flutter.dart';

class AuthService {
  /// Đăng ký tài khoản
  Future<void> signUp(String email, String password) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email, // Sử dụng AuthUserAttributeKey.email
          },
        ),
      );
      print('Sign up successful: ${result.isSignUpComplete}');
    } on AuthException catch (e) {
      // Kiểm tra nếu lỗi là do email đã tồn tại
      if (e.message.contains('UsernameExistsException')) {
        throw Exception('Email đã được đăng ký. Vui lòng sử dụng email khác hoặc đăng nhập.');
      }
      // Ném lại lỗi khác nếu không phải lỗi UsernameExistsException
      throw Exception(e.message);
    } catch (e) {
      print('Sign up failed: $e');
      throw Exception('Đã xảy ra lỗi khi đăng ký tài khoản.');
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
  /// Hàm đăng xuất
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      print('Đăng xuất thành công');
    } catch (e) {
      print('Đăng xuất thất bại: $e');
      throw Exception('Đăng xuất thất bại');
    }
  }

  Future<String?> getCurrentUsername() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      return user.username; // Trả về username
    } catch (e) {
      print('Lỗi lấy thông tin tài khoản: $e');
      return 'customer'; // Trường hợp không thể lấy thông tin
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
      print('Mã xác nhận đã được gửi đến email: $email');
    } catch (e) {
      print('Lỗi khi yêu cầu đặt lại mật khẩu: $e');
      throw e;
    }
  }
  
  Future<void> confirmResetPassword(
      String email, String confirmationCode, String newPassword) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      print('Mật khẩu đã được thay đổi thành công.');
    } catch (e) {
      print('Lỗi khi xác nhận đặt lại mật khẩu: $e');
      throw e;
    }
  }

}
