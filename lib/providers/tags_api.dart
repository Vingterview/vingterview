import 'dart:convert';

import 'package:capston/models/tags.dart';
import 'package:http/http.dart' as http;

class TagApi {
  String uri = 'https://ee-wfnlp.run.goorm.site';

  Future<List<Tags>> getTags() async {
    // 질문 전체 목록 # 0
    final response = await http.get(Uri.parse('$uri/tags'));
    final statusCode = response.statusCode;
    final body = response.body;
    List<Tags> tags = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(body);
      tags = jsonList.map((json) => Tags.fromJson(json)).toList();
    }

    return tags;
  }
}
