import 'package:flutter/material.dart';
import 'package:nhom1_signin_up/auth_service.dart';

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
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
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
              child: Text('Đăng nhập'),
            ),
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

          ],
        ),
      ),
    );
  }
}
