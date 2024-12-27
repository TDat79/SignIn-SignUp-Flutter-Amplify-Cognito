import 'package:flutter/material.dart';
import 'package:nhom1_signin_up/services/auth_service.dart';
import '../models/job.dart';
import '../services/api_service.dart';
import 'create_job_screen.dart';
import 'edit_job_screen.dart';
import 'sign_in_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  String username = 'Đang tải...'; // Giá trị mặc định

  final ApiService _apiService = ApiService('https://bj2ee0qhkb.execute-api.ap-southeast-1.amazonaws.com/JobStage/job'); // Thay thế bằng URL của bạn
  List<JobPost> _jobPosts = [];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadJobPosts(); // Thêm dòng này để tải bài đăng
  }
  void _refreshJobPosts() {
    _loadJobPosts(); // Gọi lại hàm tải dữ liệu
  }

  Future<void> _deleteJobPost(String id) async {
    // Hiển thị hộp thoại xác nhận trước khi xóa
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa bài đăng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Đóng dialog và không xóa
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Đồng ý xóa
            child: Text('Xóa'),
          ),
        ],
      ),
    );

    // Kiểm tra nếu người dùng xác nhận xóa
    if (confirmDelete == true) {
      try {
        await _apiService.deleteItem(id); // Gọi hàm xóa từ ApiService
        setState(() {
          _jobPosts.removeWhere((post) => post.id == id); // Cập nhật danh sách
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa bài đăng thất bại: $e')),
        );
      }
    }
  }

  void _navigateToCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateJobScreen()),
    );
  }

  void _navigateToEditPost(JobPost jobPost) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditJobScreen(jobPost: jobPost)),
    );
  }

  // Hàm lấy thông tin tên người dùng
  Future<void> _loadUserName() async {
    final name = await _authService.getCurrentUsername();
    setState(() {
      username = name!;
    });
  }

  Future<void> _loadJobPosts() async {
    try {
      final posts = await _apiService.fetchItems(); // Lấy dữ liệu từ API
      print(posts); // In ra để kiểm tra dữ liệu
      setState(() {
        _jobPosts =
            posts.map<JobPost>((json) => JobPost.fromJson(json)).toList();
      });
    }catch(e){
      print('Error loading job posts: $e');
    }
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
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _jobPosts.length,
        itemBuilder: (context, index) {
          final jobPost = _jobPosts[index];
          return ListTile(
            title: Text(jobPost.title),
            subtitle: Text(jobPost.description),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditJobScreen(jobPost: _jobPosts[index]),
                ),
              );
              if (result == true) {
                _loadJobPosts(); // Gọi lại hàm tải dữ liệu
              }
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteJobPost(jobPost.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateJobScreen()),
          );
          if (result == true) {
            _loadJobPosts(); // Gọi lại hàm tải dữ liệu nếu tạo thành công
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
