import 'package:flutter/material.dart';
import '../models/users.dart';
import '../models/tags.dart';
import '../providers/users_api.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/uploadmp4.dart';
import 'dart:io';

// import 'package:question_player/question_player.dart';
class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  // Define variables for the form fields
  String _id;
  String _password;
  int member_id;
  String uri = 'https://ee-wfnlp.run.goorm.site';

  // Create an instance of the API class
  UserApi _userApi = UserApi();

  // Define a form key for validation
  final _formKey = GlobalKey<FormState>();

  // Define a scaffold key for showing snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: '아이디를 입력하세요',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: '비밀번호를 입력하세요',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  int member_id = await _userApi.userLogin(
                      idController.text, passwordController.text);
                  print(member_id);
                  // 로그인 성공
                  if (member_id != null) {
                    print('로그인 성공! 회원 ID: $member_id');
                    Navigator.pushReplacementNamed(context, '/index');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('회원정보가 맞지 않습니다. 다시 시도해주세요.')),
                    );
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                  // print('로그인 성공! 회원 ID: $member_id');
                  // Navigator.pushReplacementNamed(context, '/index');
                } catch (e) {
                  // 로그인 실패
                  print(e.toString());
                }
              },
              child: Text('로그인'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text("이메일로 회원가입하기"))
          ],
        ),
      ),
    );
  }
}
