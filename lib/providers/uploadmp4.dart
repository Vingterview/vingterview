import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:capston/models/globals.dart';

class UploadVideoApi {
  Future<String> pickVideo() async {
    // 영상 업로드  # 2
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    final video_url = uploadVideo(file);
    return video_url;
  }

  Future<String> changeVideo(int id) async {
    // 영상 변경  # 6
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final video_url = updateVideo(id, pickedFile);
    return video_url;
  }

  Future<String> uploadVideo(File videoFile) async {
    //XFile에서 File로 바꿈
    String uri = myUri;
    final url = Uri.parse('$uri/boards/video');

    // open the video file
    final bytes = await videoFile.readAsBytes();

    // create the multipart request
    final request = http.MultipartRequest('POST', url)
      ..files.add(http.MultipartFile.fromBytes('video', bytes,
          filename: 'example.mp4'));

    // send the request
    final response = await request.send(); // 에러 생기는 지점 (파일 형태 때문인가??)
    final responseBody = await response.stream.bytesToString();

    // check the response status code
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(responseBody);
      final videoUrl = responseJson['video_url'];
      return videoUrl;
    } else {
      // throw Exception('Failed to post video');
      print(response.statusCode);
    }
  }

  Future<String> updateVideo(int id, XFile videoFile) async {
    String uri = myUri;
    final url = Uri.parse('$uri/boards/$id/video');

    // open the video file
    final bytes = await videoFile.readAsBytes();

    // create the multipart request
    final request = http.MultipartRequest('PATCH', url)
      ..files.add(http.MultipartFile.fromBytes('video', bytes,
          filename: 'example.mp4'));

    // send the request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    // check the response status code
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(responseBody);
      final videoUrl = responseJson['video_url'];
      return videoUrl;
    } else {
      throw Exception('Failed to post video');
    }
  }
}
