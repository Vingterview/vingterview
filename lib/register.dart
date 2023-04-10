import 'package:flutter/material.dart';
import '../models/users.dart';
import '../models/tags.dart';
import '../providers/users_api.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/uploadmp4.dart';
import 'dart:io';
import 'package:capston/models/globals.dart';

// import 'package:question_player/question_player.dart';
class registeruser extends StatefulWidget {
  @override
  _registerstate createState() => _registerstate();
}

class _registerstate extends State<registeruser> {
  String uri = myUri;
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  // Create an instance of the API class
  UserApi _userApi = UserApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
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
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력하세요',
                ),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  hintText: '나이를 입력하세요',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: '이메일을 입력하세요',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: nicknameController,
                decoration: InputDecoration(
                  hintText: '닉네임을 입력하세요',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    int memberId = await _userApi.postUser(
                      idController.text,
                      passwordController.text,
                      nameController.text,
                      int.parse(ageController.text),
                      emailController.text,
                      nicknameController.text,
                    );
                    // 회원 가입 성공
                    print('회원 가입 성공! 회원 ID: $memberId');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('회원 가입 성공! 회원 ID: $memberId')),
                    );
                    // 회원 가입 후 로그인 페이지로 이동
                    // Navigator.pushNamed(context, '/login');
                    Navigator.pop(context);
                  } catch (e) {
                    // 회원 가입 실패
                    print(e.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: Text('회원 가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
