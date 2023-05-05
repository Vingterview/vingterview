import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:capston/models/globals.dart';

class UploadImageApi {
  Future<String> pickImage() async {
    // 프로필 사진 업로드  #2
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final profile_image_url = uploadImage(pickedFile);
    return profile_image_url;
  }

  Future<String> changeImage(int id) async {
    // 프로필 사진 변경  #6
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final profile_image_url = updateImage(id, pickedFile);
    return profile_image_url;
  }

  Future<String> uploadImage(XFile imageFile) async {
    String uri = myUri;
    final url = Uri.parse('$uri/members/image');

    // open the image file
    final bytes = await imageFile.readAsBytes();

    // create the multipart request
    final request = http.MultipartRequest('POST', url)
      ..files.add(http.MultipartFile.fromBytes('profileImage', bytes,
          filename: 'example.jpg'));

    // print(request);

    // send the request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    // check the response status code
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(responseBody);
      final imageUrl = responseJson['profile_image_url'];
      return imageUrl;
    } else {
      throw Exception('Failed to post image');
    }
  }

  Future<String> updateImage(int id, XFile imageFile) async {
    String uri = myUri;
    final url = Uri.parse('$uri/members/$id/image');

    // open the image file
    final bytes = await imageFile.readAsBytes();

    // create the multipart request
    final request = http.MultipartRequest('PATCH', url)
      ..files.add(http.MultipartFile.fromBytes('profileImage', bytes,
          filename: 'example.jpg'));

    // send the request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    // check the response status code
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(responseBody);
      final videoUrl = responseJson['profile_image_url'];
      print(videoUrl);
      return videoUrl;
    } else {
      throw Exception('Failed to post video');
    }
  }
}
