import 'dart:convert';

import 'package:capston/models/users.dart';
import 'package:capston/models/questions.dart';
import 'package:capston/models/videos.dart';
import 'package:http/http.dart' as http;

class VideoApi {
  Future<List<Videos>> getVideos() async {
    final response =
        await http.get(Uri.parse('https://ee-wfnlp.run.goorm.site/videos'));
    final statusCode = response.statusCode;
    final body = response.body;
    List<Videos> videos = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(body);
      videos = jsonList.map((json) => Videos.fromJson(json)).toList();
    }

    return videos;
  }

  Future<bool> postVideo(Videos video) async {
    final response = await http.post(
      Uri.parse('https://ee-wfnlp.run.goorm.site/videos'),
      body: jsonEncode(video.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 201;
  }
}
