import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:capston/models/users.dart';
import 'package:capston/providers/users_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/uploadImg.dart';
import 'dart:io';

class UserEditPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserEditPage> {
  // Define a form key for validation
  final _formKey = GlobalKey<FormState>();
  UploadImageApi uploadImageApi = UploadImageApi();

  // Define a scaffold key for showing snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int memberId;
  String name;
  int age;
  String email;
  String nickname;
  String profilePicture;
  UserApi userApi = UserApi();
  Users userData;
  File _image;

  @override
  void initState() {
    super.initState();
    fetchUserInfo().then((_) {
      setState(() {});
    });
  }

  Future<void> fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberId = prefs.getInt('member_id');
    userData = await userApi.getUserDetail(memberId);
    print(
        '${userData.name} ${userData.age} ${userData.email} ${userData.nickName} ${userData.profile_image_url}');
    setState(() {
      name = userData.name;
      age = userData.age;
      email = userData.email;
      nickname = userData.nickName;
      profilePicture = userData.profile_image_url;
    });
  }

  Future<void> updateUserInfo() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        // print('$name $age $email $nickname $profilePicture');
        int member_id = await userApi.putRequest(
            memberId, name, age, email, nickname, profilePicture);
        print(member_id);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('회원정보가 수정되었습니다.')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('회원정보 수정에 실해했습니다.')));
      }
    }
  }

  Future<void> uploadImage() async {
    String img_url = await uploadImageApi.pickImage();
    if (img_url != null) {
      setState(() {
        profilePicture = img_url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6fa8dc), Color(0xFF8A61D4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.check), onPressed: updateUserInfo),
        ],
        title: Text(
          '회원 정보 수정하기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: userData.name,
                      decoration: InputDecoration(labelText: '이름'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '이름을 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        name = value;
                      },
                    ),
                    TextFormField(
                      initialValue: userData.age.toString(),
                      decoration: InputDecoration(labelText: '나이'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '나이를 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        age = int.parse(value); // 문자열 값을 정수형으로 변환하여 저장
                      },
                    ),
                    TextFormField(
                      initialValue: userData.nickName,
                      decoration: InputDecoration(labelText: '닉네임'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '닉네임을 입력해주세요';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nickname = value;
                      },
                    ),
                    TextFormField(
                      initialValue: userData.email,
                      decoration: InputDecoration(labelText: '이메일'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '이메일을 입력해주세요';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(height: 16.0),

                    // if (profilePicture != null)
                    //   Image.network(
                    //     profilePicture,
                    //     width: 100.0,
                    //     height: 100.0,
                    //     fit: BoxFit.cover,
                    //   ),
                    // <------------------------------------ 사진링크가 유효하지 않아서 꺼둠
                    SizedBox(height: 8.0),
                    if (_image != null) Image.file(_image),
                    ElevatedButton(
                      child: Text('사진 업로드'),
                      onPressed: uploadImage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
