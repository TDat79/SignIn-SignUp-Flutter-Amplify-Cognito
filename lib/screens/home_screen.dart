import 'package:flutter/material.dart';
import 'package:nhom1_signin_up/auth_service.dart';
import 'sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  String username = 'Đang tải...'; // Giá trị mặc định

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Hàm lấy thông tin tên người dùng
  Future<void> _loadUserName() async {
    final name = await _authService.getCurrentUsername();
    setState(() {
      username = name!;
    });
  }

  void _logout(BuildContext context) async {
    // Hiển thị hộp thoại xác nhận
    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận đăng xuất'),
        content: Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Đóng dialog, không đăng xuất
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Đồng ý đăng xuất
            child: Text('Đăng xuất'),
          ),
        ],
      ),
    );

    // Kiểm tra nếu người dùng xác nhận đăng xuất
    if (confirmLogout == true) {
      try {
        await _authService.signOut();

        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
              (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng xuất thất bại: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
        actions: [
          Center(
            child: Text(
              username,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), // Gọi hàm đăng xuất
          ),
        ],
      ),
      body: Center(
        child: Text('Chào mừng đến với ứng dụng!'),
      ),
    );
  }
}
