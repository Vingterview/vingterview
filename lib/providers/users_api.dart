import 'dart:convert';

import 'package:capston/models/users.dart';
import 'package:http/http.dart' as http;

class UserApi {
  Future<Users> getUser(int id) async {
    final response = await http
        .get(Uri.parse('https://ee-wfnlp.run.goorm.site/user_info/id=$id'));
    final statusCode = response.statusCode;
    final body = response.body;
    Users user;

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      user = Users.fromJson(jsonMap);
    }

    return user;
  }
}