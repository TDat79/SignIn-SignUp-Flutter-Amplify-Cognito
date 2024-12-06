import 'package:flutter/material.dart';
import 'package:nhom1_signin_up/auth_service.dart';

class SignInScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
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
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                final success = await authService.signIn(email, password);

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
              child: Text('Sign In'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don’t have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUp');
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
