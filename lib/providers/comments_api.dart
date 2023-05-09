import 'dart:convert';

import 'package:capston/models/globals.dart';
import 'package:capston/models/comments.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentApi {
  String uri = myUri;
  Future<List<Comments>> getcomments(int query, int id) async {
    // 댓글 목록 조회 # 0
    // 0 = 게시글로 필터링
    // 1 = 작성자로 필터링
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    List<String> queries = ["?board_id=", "?member_id="];
    final response = await http.get(
      Uri.parse('$uri/comments${queries[query]}$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    List<Comments> comments = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(utf8.decode(bodyBytes))['comments'];
      comments = jsonList.map((json) => Comments.fromJson(json)).toList();
    }

    return comments;
  }

  Future<int> postcomment(int board_id, String content) async {
    // 댓글 등록   # 1
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    final response = await http.post(
      Uri.parse('$uri/comments'),
      body: jsonEncode({
        'boardId': board_id,
        'content': content,
      }),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['commentId'];
    } else {
      print(response.statusCode);
      print("err");
    }
  }

  Future<Comments> getcommentDetail(int id) async {
    // 댓글 조회 # 3
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('$uri/comments/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    Comments comment;

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      comment = Comments.fromJson(jsonMap);
    }

    return comment;
  }

  Future<void> deletecomment(int id) async {
    // 댓글 삭제 # 4
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var url = Uri.parse('$uri/comments/$id');
    var response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      print('Delete request succeeded');
    } else {
      throw Exception('Failed to delete comment');
    }
  }

  Future<int> putRequest(Comments comment) async {
    // 댓글 수정  # 5
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var url = Uri.parse('$uri/boards/${comment.commentId}');
    var headers = {'Authorization': 'Bearer $token'};
    var body = jsonEncode(comment.toJson());

    var response = await http.put(url, headers: headers, body: body);
    final bodyBytes = response.bodyBytes;

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      return jsonMap['commentId'];
    } else {
      throw Exception('Failed to post comment');
    }
  }

  Future<void> like(int id) async {
    // 라이크  # 7
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var url = Uri.parse('$uri/boards/$id/like');

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    final bodyBytes = response.bodyBytes;

    if (response.statusCode == 204) {
      print(utf8.decode(bodyBytes));
    } else {
      throw Exception('좋아요 실패');
    }
  }
}
