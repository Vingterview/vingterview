import 'dart:convert';
import 'package:capston/models/users.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capston/models/globals.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserApi {
  String uri = myUri;

  Future<List<Users>> getUsers() async {
    // 회원 전체 목록 # 0
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('$uri/members'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json;charset=UTF-8'
      },
    );
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
      headers: {'Content-Type': 'application/json;charset=UTF-8'},
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('$uri/members/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json;charset=UTF-8'
      },
    );
    final statusCode = response.statusCode;
    final bodyBytes = response.bodyBytes;
    Users user;
    print(utf8.decode(bodyBytes));
    if (statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(bodyBytes));
      user = Users.fromJson(jsonMap);
    }

    return user;
  }

  Future<void> deleteUser(int id) async {
    // 회원 탈퇴 # 4
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var url = Uri.parse('$uri/members/$id');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json;charset=UTF-8'
    };
    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 204) {
      print('Delete request succeeded');
    } else {
      throw Exception('회원 삭제 실패');
    }
  }

  Future<int> putRequest(int id, String name, int age, String email,
      String nickname, String profileImageUrl) async {
    // 회원 정보 변경  # 5
    var url = Uri.parse('$uri/members/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json;charset=UTF-8'
    };
    var body = jsonEncode({
      'name': name,
      'age': age,
      'email': email,
      'nickname': nickname,
      'profile_image_url': profileImageUrl,
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
    // 로그인 #7
    // final String url = '$uri/login';
    // final headers = {
    //   'Authorization': 'Bearer $token',
    //   'Content-Type': 'application/json',
    // };
    // final response = await http.get(Uri.parse(url));
    // if (response.statusCode == 200) {
    //   // login successful
    //   return true;
    //   // use the access token as needed
    // } else if (response.statusCode == 302) {
    //   final loginUrl = json.decode(response.body)['login_url'];
    //   final loginResponse = await http.get(Uri.parse(loginUrl));
    //   if (loginResponse.statusCode == 200) {
    //     // login successful
    //     final accessToken = json.decode(loginResponse.body)['access_token'];
    //     // use the access token as needed
    //   } else {
    //     // handle login error
    //   }
    // }

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
    String token = prefs.getString('access_token');
    prefs.setBool('isLogin', false);
    prefs.setString('id', '');
    prefs.setString('password', '');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 204) {
      print('Logout successful');
    } else {
      throw Exception('로그 아웃 실패');
    }
  }
}
