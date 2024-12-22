import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/api_service.dart';


class CreateJobScreen extends StatefulWidget {
  @override
  _CreateJobScreenState createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final ApiService _apiService = ApiService('https://bj2ee0qhkb.execute-api.ap-southeast-1.amazonaws.com/JobStage/job'); // Thay bằng URL của bạn
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  Future<void> _createPost() async {
    // Kiểm tra nếu tiêu đề hoặc mô tả trống
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin.')),
      );
      return; // Dừng lại nếu không hợp lệ
    }
    final newPost = JobPost(
      id: generateJobId(), // ID sẽ được tạo ra từ server
      title: titleController.text,
      description: descriptionController.text,
      company: companyController.text,
      location: locationController.text,
      salary: double.tryParse(salaryController.text) ?? 0.0,
    );

    try {
      await _apiService.createItem(newPost.toJson());
      Navigator.pop(context, true); // Quay lại trang trước
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo bài đăng thất bại: $e')),
      );
    }
  }
  //Hàm tạo JobID
  String generateJobId() {
    return 'job_${DateTime.now().millisecondsSinceEpoch}'; // Tạo ID duy nhất
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo Bài Đăng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              controller: companyController,
              decoration: InputDecoration(labelText: 'Công ty'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Địa chỉ'),
            ),
            TextField(
              controller: salaryController,
              decoration: InputDecoration(labelText: 'Lương theo giờ'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPost,
              child: Text('Tạo Bài Đăng'),
            ),
          ],
        ),
      ),
    );
  }
}