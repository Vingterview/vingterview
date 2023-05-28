import 'dart:convert';

import 'package:capston/models/globals.dart';
import 'package:capston/models/videos.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PageVideos {
  List<Videos> videos;
  final int nextPage;
  final bool hasNext;

  PageVideos({this.videos, this.nextPage, this.hasNext});

  factory PageVideos.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonVideos = json['boards'];
    // print(jsonTags);
    List<Videos> _videos = jsonVideos != null
        ? jsonVideos.map((videos) => Videos.fromJson(videos)).toList()
        : [];
    return PageVideos(
      videos: _videos,
      nextPage: json['next_page'],
      hasNext: json['has_next'],
    );
  }

  void changeList(List<Videos> videos) {
    this.videos = videos;
  }
}

class VideoDetail {
  final Videos video;
  final bool like;

  VideoDetail({this.video, this.like});

  factory VideoDetail.fromJson(Map<String, dynamic> json) {
    Videos _video = Videos.fromJson(json["board_dto"]);
    // print(jsonTags);
    bool _like = json["like"];
    return VideoDetail(video: _video, like: _like);
  }
}

class VideoApi {
  String uri = myUri;
  Future<PageVideos> getVideos(
      {int query = 0,
      String param = "",
      int page = 0,
      String sort = ""}) async {
    // String으로 받는 거 기억하기!!
    // 게시글 전체 목록 # 0
    // 0 : 전부(default) , 1 : 작성자로 필터링, 2 : 질문으로 필터링, 3 : 정렬 (좋아요순, 댓글순, 최신순)
    List<String> queries = [
      "?page=$page$sort",
      "?page=$page&member_id=$param",
      "?page=$page&question_id=$param",
      "?page=$page&order_by=$param$sort"
    ];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('$uri/boards${queries[query]}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    PageVideos videos;
    // print(utf8.decode(bodyBytes));

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      videos = PageVideos.fromJson(jsonMap);
    }
    return videos;
  }

  Future<int> postVideo(
      int question_id, String content, String video_url) async {
    // 게시글 등록   # 1
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    final response = await http.post(
      Uri.parse('$uri/boards'),
      body: jsonEncode({
        'question_id': question_id,
        'content': content,
        'video_url': video_url
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json;charset=UTF-8'
      },
    );
    print("$question_id $content $video_url");

    if (response.statusCode == 201) {
      final bodyBytes = response.bodyBytes;
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      return jsonMap['board_id'];
    } else {
      throw Exception('Failed to post video');
    }
  }

  Future<VideoDetail> getVideoDetail(int id) async {
    // 게시글 조회 # 3
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    final response = await http.get(Uri.parse('$uri/boards/$id'),
        headers: {'Authorization': 'Bearer $token'});
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;

    VideoDetail video;

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      video = VideoDetail.fromJson(jsonMap);
    }

    return video;
  }

  Future<void> deleteVideo(int id) async {
    // 게시글 삭제 # 4
    var url = Uri.parse('$uri/boards/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var response =
        await http.delete(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 204) {
      print('Delete request succeeded');
    } else {
      throw Exception('Failed to delete video');
    }
  }

  Future<int> putRequest(
      int id, int question_id, String content, String video_url) async {
    // 얘네가 null이면 안 된다!!
    // 게시글 수정  # 5
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var url = Uri.parse('$uri/boards/$id');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json;charset=UTF-8'
    };
    var body = jsonEncode({
      'question_id': question_id,
      'content': content,
      'video_url': video_url
    });

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final bodyBytes = response.bodyBytes;
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      return jsonMap['board_id'];
    } else {
      print(utf8.decode(response.bodyBytes));
      print(response.statusCode);
      throw Exception('Failed to post video');
    }
  }

  Future<void> like(int id) async {
    // 라이크  # 7
    var url = Uri.parse('$uri/boards/$id/like');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 204) {
      final bodyBytes = response.bodyBytes;
      print(utf8.decode(bodyBytes));
    } else {
      // throw Exception('좋아요 실패');
      print(response.body);
    }
  }
}
