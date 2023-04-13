import 'dart:convert';
import 'package:capston/models/users.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capston/models/globals.dart';

class UserApi {
  String uri = myUri;

  Future<List<Users>> getUsers() async {
    // 회원 전체 목록 # 0
    final response = await http.get(Uri.parse('$uri/members'));
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    List<Users> users = [];

    if (statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(utf8.decode(bodyBytes))['users'];
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
      final bodyBytes = response.bodyBytes;
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      return jsonMap['member_id'];
    } else {
      throw Exception('회원 등록 실패');
    }
  }

  Future<Users> getUserDetail(int id) async {
    // 회원 조회 # 3
    final response = await http.get(Uri.parse('$uri/members/$id'));
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    Users user;

    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
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
      throw Exception('회원 삭제 실패');
    }
  }

  Future<int> putRequest(
      // put request인데 비밀번호 없는거 의도하신건지
      String id,
      String name,
      int age,
      String email,
      String nickname) async {
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

    var response = await http.put(url, headers: headers, body: body);

    final bodyBytes = response.bodyBytes;
    if (response.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      return jsonMap['member_id'];
    } else {
      throw Exception('회원 수정 실패');
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
      SharedPreferences prefs =
          await SharedPreferences.getInstance(); // 멤버 변수 저장하기
      prefs.setBool('isLogin', true);
      prefs.setString('id', id);
      prefs.setString('password', password);
      final bodyBytes = response.bodyBytes;
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      prefs.setInt('member_id', jsonMap['member_id']);
      return jsonMap['member_id'];
    } else {
      throw Exception('로그인 실패');
    }
  }

  Future<void> logoutUser() async {
    // 로그아웃 # 8
    var url = Uri.parse('$uri/logout');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setString('id', '');
    prefs.setString('password', '');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_AUTH_TOKEN',
      },
    );

    if (response.statusCode == 201) {
      print('Logout successful');
    } else {
      throw Exception('로그 아웃 실패');
    }
  }
}
