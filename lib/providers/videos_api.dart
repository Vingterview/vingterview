import 'dart:convert';

import 'package:capston/models/globals.dart';
import 'package:capston/models/videos.dart';
import 'package:http/http.dart' as http;

class VideoApi {
  String uri = myUri;
  Future<List<Videos>> getVideos({int query = 0, String param = ""}) async {
    // String으로 받는 거 기억하기!!
    // 게시글 전체 목록 # 0
    // 0 : 전부(default) , 1 : 작성자로 필터링, 2 : 질문으로 필터링, 3 : 정렬 (좋아요순, 댓글순, 최신순)
    List<String> queries = ["", "?member_id=", "?question_id=", "?order_by="];
    final response =
        await http.get(Uri.parse('$uri/boards${queries[query]}$param'));
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    List<Videos> videos = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(utf8.decode(bodyBytes))['boards'];
      videos = jsonList.map((json) => Videos.fromJson(json)).toList();
    }

    return videos;
  }

  Future<int> postVideo(
      int question_id, int member_id, String content, String video_url) async {
    // 게시글 등록   # 1
    final response = await http.post(
      Uri.parse('$uri/boards'),
      body: jsonEncode({
        'question_id': question_id,
        'member_id': member_id,
        'content': content,
        'video_url': video_url
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final bodyBytes = response.bodyBytes;
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      return jsonMap['board_id'];
    } else {
      throw Exception('Failed to post video');
    }
  }

  Future<Videos> getVideoDetail(int id) async {
    // 게시글 조회 # 3
    final response = await http.get(Uri.parse('$uri/boards/$id'));
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    Videos video;

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
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
      throw Exception('Failed to delete video');
    }
  }

  Future<int> putRequest(int id, int question_id, String content) async {
    // put인데 이거만 있어도 되는지
    // 게시글 수정  # 5
    var url = Uri.parse('$uri/boards/$id');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'question_id': question_id, 'content': content});

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final bodyBytes = response.bodyBytes;
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
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
      final bodyBytes = response.bodyBytes;
      print(utf8.decode(bodyBytes));
    } else {
      throw Exception('좋아요 실패');
    }
  }
}
