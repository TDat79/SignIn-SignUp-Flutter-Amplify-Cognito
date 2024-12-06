import 'package:flutter/material.dart';
import 'package:nhom1_signin_up/auth_service.dart';
import 'confirm_sign_up_screen.dart';
import 'package:email_validator/email_validator.dart';  // Import package kiểm tra định dạng email
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  // Kiểm tra mật khẩu hợp lệ theo các yêu cầu của Cognito
  bool isPasswordValid(String password) {
    // Các yêu cầu cơ bản cho mật khẩu của Cognito (8 ký tự, ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt)
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  void _signUp() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email không được để trống')),
      );
      return;
    } else if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Địa chỉ email không hợp lệ')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu không được để trống')),
      );
      return;
    }

    // Kiểm tra mật khẩu có hợp lệ hay không
    if (!isPasswordValid(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu không hợp lệ. Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt')),
      );
      return;
    }

    try {
      // Gọi hàm đăng ký từ AuthService
      await _authService.signUp(email, password);

      // Điều hướng đến màn hình nhập OTP, truyền email qua tham số
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(email: email),  // Truyền email
        ),
      );
    } catch (e) {
      // Xử lý lỗi đăng ký từ Cognito, thông báo mật khẩu không hợp lệ
      String errorMessage = 'Đăng ký thất bại';

      // Kiểm tra nếu lỗi là do mật khẩu không hợp lệ theo quy tắc Cognito
      if (e.toString().contains('password')) {
        errorMessage = 'Mật khẩu không hợp lệ. Đảm bảo mật khẩu của bạn đáp ứng các yêu cầu của hệ thống';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký tài khoản')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
