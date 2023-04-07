import 'dart:convert';

import 'package:capston/models/users.dart';
import 'package:capston/models/questions.dart';
import 'package:capston/models/videos.dart';
import 'package:http/http.dart' as http;

class VideoApi {
  String uri = 'https://ee-wfnlp.run.goorm.site';
  Future<List<Videos>> getVideos() async {
    // 게시글 전체 목록 # 0
    final response = await http.get(Uri.parse('$uri/boards'));
    final statusCode = response.statusCode;
    final body = response.body;
    List<Videos> videos = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(body);
      videos = jsonList.map((json) => Videos.fromJson(json)).toList();
    }

    return videos;
  }

  Future<int> postVideo(int question_id, int member_id, String content) async {
    // 게시글 등록   # 1
    final response = await http.post(
      Uri.parse('$uri/boards'),
      body: jsonEncode({
        'question_id': question_id,
        'member_id': member_id,
        'content': content
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['board_id'];
    } else {
      throw Exception('Failed to post video');
    }
  }

  Future<Videos> getVideoDetail(int id) async {
    // 게시글 조회 # 3
    final response = await http.get(Uri.parse('$uri/boards/$id'));
    final statusCode = response.statusCode;
    final body = response.body;
    Videos video;

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      video = Videos.fromJson(jsonMap);
    }

    return video;
  }

  Future<void> deleteVideo(int id) async {
    // 게시글 삭제 # 4
    var url = Uri.parse('$uri/boards/$id');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Delete request succeeded');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> patchRequest(int id, int question_id, String content) async {
    // 게시글 수정  # 5
    var url = Uri.parse('$uri/boards/$id');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'question_id': question_id, 'content': content});

    var response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['board_id'];
    } else {
      throw Exception('Failed to post video');
    }
  }

  Future<void> like(int id) async {
    // 라이크  # 7
    var url = Uri.parse('$uri/boards/$id/like');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
