import 'dart:convert';

import 'package:capston/models/globals.dart';
import 'package:capston/models/questions.dart';
import 'package:capston/models/tags.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PageQuestions {
  List<Questions> questions;
  final int nextPage;
  final bool hasNext;

  PageQuestions({this.questions, this.nextPage, this.hasNext});

  factory PageQuestions.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonQuestions = json['questions'];
    // print(jsonTags);
    List<Questions> _questions = jsonQuestions != null
        ? jsonQuestions
            .map((questions) => Questions.fromJson(questions))
            .toList()
        : [];
    return PageQuestions(
      questions: _questions,
      nextPage: json['next_page'],
      hasNext: json['has_next'],
    );
  }

  void changeList(List<Questions> questions) {
    this.questions = questions;
  }
}

class QuestionApi {
  String uri = myUri;

  Future<PageQuestions> getQuestions(
      {int query = 0, String param = "", int page = 0}) async {
    // 질문 전체 목록 # 0
    // 0 : 전부(default) , 1 : 태그로 필터링, 2 : 작성자로 필터링,
    // 3 : 스크랩 필터링, 4 : 정렬 (좋아요순, 댓글순, 최신순)

    List<String> queries = [
      "?page=$page",
      "?page=$page&tag_id=$param",
      "?page=$page&member_id=$param",
      "?page=$page&scrap_member_id=$param",
      "?page=$page&order_by=$param"
    ];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    print("$uri/questions${queries[query]} 시작");
    final response = await http.get(
      Uri.parse('$uri/questions${queries[query]}'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes; // 한국어 깨짐 해결용 수정
    PageQuestions questions;
    print("$uri/questions${queries[query]} 끝");

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes)); // 한국어
      questions = PageQuestions.fromJson(jsonMap);
    }

    return questions;
  }

  Future<int> postQuestion(List<Tags> tags, String question_content) async {
    // 질문 등록   # 1

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    List<int> postTags = [];
    for (int i = 0; i < postTags.length; i++) {
      postTags.add(tags[i].tagId);
    }
    final response = await http.post(
      Uri.parse('$uri/questions'),
      body:
          jsonEncode({'tags': postTags, 'question_content': question_content}),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json;charset=UTF-8'
      },
    );
    print(response.statusCode);

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['question_id'];
    } else {
      throw Exception('Failed to post question');
    }
  }

  Future<void> scrap(int id) async {
    // 스크랩  # 3
    var url = Uri.parse('$uri/questions/$id/scrap');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 204) {
      print("스크랩 성공");
    } else {
      throw Exception('스크랩 실패');
    }
  }
}
