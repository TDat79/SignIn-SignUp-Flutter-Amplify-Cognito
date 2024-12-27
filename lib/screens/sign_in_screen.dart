import 'package:flutter/material.dart';
import 'package:nhom1_signin_up/services/auth_service.dart';

import 'forgot_pass_screen.dart';

class SignInScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16), // Khoảng cách giữa các trường
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 16), // Khoảng cách trước nút đăng nhập
            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text;
                final password = passwordController.text;
                final success = await authService.signIn(username, password);

                if (success) {
                  // Điều hướng đến màn hình chính sau khi đăng nhập thành công
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Hiển thị thông báo lỗi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed. Please try again.')),
                  );
                }
              },
              child: Center(child: Text('Đăng nhập')),
            ),
            SizedBox(height: 16), // Khoảng cách trước dòng đăng ký
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bạn chưa có tài khoản?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUp');
                  },
                  child: Text('Đăng ký'),
                ),
              ],
            ),
            SizedBox(height: 24), // Tạo khoảng cách lớn hơn
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // Điều hướng đến màn hình quên mật khẩu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ForgotPasswordScreen(), // Điều hướng đến ForgotPasswordScreen
                    ),
                  );
                },
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
