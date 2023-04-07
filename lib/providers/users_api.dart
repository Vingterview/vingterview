import 'dart:convert';
import 'package:capston/models/users.dart';
import 'package:http/http.dart' as http;

class UserApi {
  String uri = 'https://ee-wfnlp.run.goorm.site';

  Future<List<Users>> getUsers() async {
    // 회원 전체 목록 # 0
    final response = await http.get(Uri.parse('$uri/members'));
    final statusCode = response.statusCode;
    final body = response.body;
    List<Users> users = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(body);
      users = jsonList.map((json) => Users.fromJson(json)).toList();
    }

    return users;
  }

  Future<int> postUser(String id, String password, String name, int age,
      String email, String nickname) async {
    // 회원 등록   # 1
    final response = await http.post(
      Uri.parse('$uri/members'),
      body: jsonEncode({
        'id': id,
        'password': password,
        'name': name,
        'age': age,
        'email': email,
        'nickname': nickname,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['member_id'];
    } else {
      throw Exception('Failed to post video');
    }
  }

  Future<Users> getUserDetail(int id) async {
    // 회원 조회 # 3
    final response = await http.get(Uri.parse('$uri/members/$id'));
    final statusCode = response.statusCode;
    final body = response.body;
    Users user;

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      user = Users.fromJson(jsonMap);
    }

    return user;
  }

  Future<void> deleteUser(int id) async {
    // 회원 탈퇴 # 4
    var url = Uri.parse('$uri/members/$id');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Delete request succeeded');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> patchRequest(
      String id, String name, int age, String email, String nickname) async {
    // 회원 정보 변경  # 5
    var url = Uri.parse('$uri/members/$id');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'id': id,
      'name': name,
      'age': age,
      'email': email,
      'nickname': nickname
    });

    var response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['member_id'];
    } else {
      throw Exception('Failed to post video');
    }
  }

  Future<int> userLogin(String id, String password) async {
    // 로그인   # 7
    final response = await http.post(
      Uri.parse('$uri/login'),
      body: jsonEncode({
        'id': id,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['member_id'];
    } else {
      throw Exception('Failed to post video');
    }
  }

  Future<void> logoutUser() async {
    // 로그아웃 # 8
    var url = Uri.parse('$uri/logout');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_AUTH_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      print('Logout successful');
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
