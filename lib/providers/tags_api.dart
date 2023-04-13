import 'dart:convert';

import 'package:capston/models/tags.dart';
import 'package:http/http.dart' as http;
import 'package:capston/models/globals.dart';

class TagApi {
  String uri = myUri;

  Future<List<Tags>> getTags({int query = 0, String param = ""}) async {
    // 질문 전체 목록 # 0
    // 0 : 대분류 , 1 : 중, 소분류
    List<String> queries = [
      "",
      "?parent_tag_id=",
    ];

    final response =
        await http.get(Uri.parse('$uri/tags${queries[query]}$param'));
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    List<Tags> tags = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(utf8.decode(bodyBytes))['tags'];
      tags = jsonList.map((json) => Tags.fromJson(json)).toList();
    }

    return tags;
  }
}
