import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:capston/models/globals.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class UploadVideoApi {
  Future<XFile> returnVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<String> pickVideo(XFile pickedFile) async {
    // 영상 업로드  # 2
    if (pickedFile == null) {
      return "";
    }
    // final video_url = uploadVideo(pickedFile);
    final outputPath = await compressVideo(pickedFile);
    XFile compressed = XFile(outputPath);
    final video_url = uploadVideo(compressed);
    print("업로드 된 영상 url :$video_url");
    return video_url;
  }

  Future<String> changeVideo(int id) async {
    // 영상 변경  # 6
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final video_url = updateVideo(id, pickedFile);
    return video_url;
  }

  Future<String> compressVideo(XFile videoFile) async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    final inputPath = videoFile.path;
    final outputPath = '${Directory.systemTemp.path}/compressed_video.mp4';
    deleteFileIfExists(outputPath);

    final arguments = ['-i', inputPath, '-vf', 'scale=640:480', outputPath];

    int result = await _flutterFFmpeg.executeWithArguments(arguments);

    if (result == 0) {
      print('영상 압축이 완료되었습니다. 압축된 비디오 파일: $outputPath');
      // 압축된 비디오 파일을 원하는 대상으로 이용하세요.
    } else {
      print('영상 압축 중 오류가 발생했습니다. 오류 코드: $result');
    }

    return outputPath;
  }

  void deleteFileIfExists(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
      print('임시 파일이 삭제되었습니다: $filePath');
    } else {
      print('삭제할 파일이 존재하지 않습니다: $filePath');
    }
  }

  Future<String> uploadVideo(XFile videoFile) async {
    //XFile에서 File로 바꿈
    String uri = myUri;
    final url = Uri.parse('$uri/boards/video');

    // open the video file
    final bytes = await videoFile.readAsBytes();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    // create the multipart request

    final request = http.MultipartRequest('POST', url)
      ..files.add(http.MultipartFile.fromBytes('video', bytes,
          filename: 'example.mp4'));

    request.headers['Authorization'] = 'Bearer $token';

    // send the request
    final response = await request.send(); // 에러 생기는 지점
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
