import 'dart:convert';

import 'package:capston/models/globals.dart';
import 'package:capston/models/comments.dart';
import 'package:http/http.dart' as http;

class CommentApi {
  String uri = myUri;
  Future<List<Comments>> getcomments(int query, int id) async {
    // 댓글 목록 조회 # 0
    // 0 = 게시글로 필터링
    // 1 = 작성자로 필터링
    List<String> queries = ["?board_id=", "?member_id="];
    final response =
        await http.get(Uri.parse('$uri/comments${queries[query]}$id'));
    final statusCode = response.statusCode;
    final body = response.body;
    List<Comments> comments = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(body)['comments'];
      comments = jsonList.map((json) => Comments.fromJson(json)).toList();
    }

    return comments;
  }

  Future<int> postcomment(int board_id, int member_id, String content) async {
    // 댓글 등록   # 1
    final response = await http.post(
      Uri.parse('$uri/comments'),
      body: jsonEncode({
        'board_id': board_id,
        'member_id': member_id,
        'content': content,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['comment_id'];
    } else {
      throw Exception('Failed to post comment');
    }
  }

  Future<Comments> getcommentDetail(int id) async {
    // 댓글 조회 # 3
    final response = await http.get(Uri.parse('$uri/comments/$id'));
    final statusCode = response.statusCode;
    final body = response.body;
    Comments comment;

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(body);
      comment = Comments.fromJson(jsonMap);
    }

    return comment;
  }

  Future<void> deletecomment(int id) async {
    // 댓글 삭제 # 4
    var url = Uri.parse('$uri/comments/$id');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Delete request succeeded');
    } else {
      throw Exception('Failed to delete comment');
    }
  }

  Future<int> putRequest(Comments comment) async {
    // 댓글 수정  # 5
    var url = Uri.parse('$uri/boards/${comment.commentId}');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(comment.toJson());

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['comment_id'];
    } else {
      throw Exception('Failed to post comment');
    }
  }

  Future<void> like(int id) async {
    // 라이크  # 7
    var url = Uri.parse('$uri/boards/$id/like');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('좋아요 실패');
    }
  }
}
