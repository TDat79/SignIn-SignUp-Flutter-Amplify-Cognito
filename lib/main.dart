import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:nhom1_signin_up/screens/sign_in_screen.dart';
import 'package:nhom1_signin_up/screens/sign_up_screen.dart';
import 'package:nhom1_signin_up/screens/confirm_sign_up_screen.dart';  // Đây là màn hình nhập OTP
import 'package:nhom1_signin_up/screens/home_screen.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Cấu hình Amplify
  await _configureAmplify();
  runApp(MyApp());
}

Future<void> _configureAmplify() async {
  // Khởi tạo plugin Auth
  final authPlugin = AmplifyAuthCognito();

  // Cấu hình Amplify với các plugin cần thiết
  await Amplify.addPlugins([authPlugin]);
  // Cấu hình Amplify với cấu hình của bạn
  try {
    // Cấu hình Amplify với thông tin từ AWS
    await Amplify.configure(amplifyconfig); // `amplifyconfig` là cấu hình của bạn từ AWS Amplify Console
    print('Amplify configured successfully');
  } catch (e) {
    print('Amplify configuration failed: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt banner "DEBUG"
      title: 'Part-time App',
      // Thiết lập initialRoute là màn hình đầu tiên khi ứng dụng chạy
      initialRoute: '/signIn', // Màn hình đăng nhập sẽ là màn hình đầu tiên
      routes: {
        '/signIn': (context) => SignInScreen(),           // Đăng nhập
        '/signUp': (context) => SignUpScreen(),           // Đăng ký
        '/confirmSignUp': (context) => OtpScreen(email: ''),  // Màn hình nhập OTP
        '/home': (context) => HomeScreen(),               // Màn hình chính sau khi đăng nhập thành công
      },
    );
  }
}
