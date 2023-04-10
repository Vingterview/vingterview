import 'dart:convert';

import 'package:capston/models/globals.dart';
import 'package:capston/models/questions.dart';
import 'package:capston/models/tags.dart';
import 'package:http/http.dart' as http;

class QuestionApi {
  String uri = myUri;

  Future<List<Questions>> getQuestions() async {
    // 질문 전체 목록 # 0
    final response = await http.get(Uri.parse('$uri/questions'));
    final statusCode = response.statusCode;
    final body = response.body;
    List<Questions> questions = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(body);
      questions = jsonList.map((json) => Questions.fromJson(json)).toList();
    }

    return questions;
  }

  Future<int> postQuestion(
      List<Tags> tags, int member_id, String question_content) async {
    // 질문 등록   # 1
    final response = await http.post(
      Uri.parse('$uri/questions'),
      body: jsonEncode({
        'tags': tags,
        'member_id': member_id,
        'question_content': question_content
      }),
      headers: {'Content-Type': 'application/json'},
    );

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

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
