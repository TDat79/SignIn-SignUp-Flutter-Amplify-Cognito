import 'package:flutter/material.dart';
import 'package:nhom1_signin_up/auth_service.dart';  // Đảm bảo bạn import đúng AuthService
import 'sign_in_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;  // Nhận email từ SignUpScreen

  // Constructor nhận tham số email
  OtpScreen({required this.email});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Khởi tạo TextEditingController để điều khiển trường nhập OTP
  final otpController = TextEditingController();

  // Thêm phương thức _confirmOtp để xác thực OTP
  void _confirmOtp() async {
    final otp = otpController.text;

    if (otp.isNotEmpty) {
      try {
        // Gọi hàm confirmSignUp từ AuthService để xác thực OTP
        await AuthService().confirmSignUp(widget.email, otp);

        // Nếu OTP đúng, chuyển đến màn hình đăng nhập
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      } catch (e) {
        // Hiển thị lỗi nếu OTP không đúng hoặc có lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xác thực OTP thất bại: $e')),
        );
      }
    } else {
      // Hiển thị lỗi nếu OTP trống
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập mã OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhập OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField để nhập mã OTP
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'Mã OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            // Nút xác thực OTP
            ElevatedButton(
              onPressed: _confirmOtp,
              child: Text('Xác thực OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
