import 'package:flutter/material.dart';
import 'package:nhom1_signin_up/services/auth_service.dart';
import 'confirm_sign_up_screen.dart';
import 'package:email_validator/email_validator.dart';  // Import package kiểm tra định dạng email

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  // Kiểm tra mật khẩu hợp lệ theo các yêu cầu của Cognito
  bool isPasswordValid(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  void _signUp() async {
    final email = emailController.text.trim(); // Loại bỏ khoảng trắng thừa
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    String errorMessage = 'Đăng ký thất bại. Vui lòng thử lại.';

    // Kiểm tra nếu email để trống hoặc không hợp lệ
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

    // Kiểm tra nếu password để trống
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

    // Kiểm tra xác nhận mật khẩu
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu và xác nhận mật khẩu không khớp')),
      );
      return;
    }
    try {
      // Gọi hàm đăng ký từ AuthService
      await _authService.signUp(email, password);

      // Kiểm tra nếu widget vẫn còn tồn tại trước khi điều hướng
      if (!mounted) return;

      // Điều hướng đến màn hình nhập OTP, truyền email qua tham số
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(email: email), // Truyền email
        ),
      );
    } catch (e) {
      // Kiểm tra nếu widget vẫn còn tồn tại trước khi hiển thị thông báo
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
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
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Xác nhận mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20), // Thêm khoảng cách giữa nút và các trường nhập
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Đăng ký'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bạn muốn đăng nhập ?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signIn');
                  },
                  child: Text('Đăng nhập'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}