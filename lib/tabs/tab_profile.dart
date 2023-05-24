import 'package:flutter/material.dart';
import 'dart:io';
import '../models/users.dart';
import '../providers/users_api.dart';
import '../providers/uploadImg.dart';
import '../providers/uploadmp4.dart';
import 'package:capston/models/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capston/mypage/my_videos.dart';
import 'package:capston/mypage/scrap_questions.dart';

class MyPage extends StatelessWidget {
  UserApi userApi = UserApi();
  Users user;
  bool isLoading = true;
  UploadImageApi uploadImageApi = UploadImageApi();
  UploadVideoApi uploadVideoApi = UploadVideoApi();
  File _image;
  String uri = myUri;
  int memberId;

  Future initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberId = prefs.getInt('member_id'); // 'member_id'라는 키로 저장한 값 가져오기
    print(memberId);
    userApi.getUserDetail(memberId);
    if (memberId != null) {
      user = await userApi.getUserDetail(memberId);
    } else {
      user = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    initUser();
    print(memberId);

    return Container(
        child: ListView(children: [
      Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Text(
            '마이 페이지',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      Padding(
        padding: EdgeInsets.all(30.0), // 여백 크기를 지정합니다
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Text(
                '내 활동',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/user_edit',
                      arguments: memberId);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '내정보 수정',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyVideoPage(
                            member_id: memberId), // Provide the index here
                      ));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '작성한 글',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  // 댓글 단 글에 대한 동작 처리
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '작성한 댓글',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScrapQuestionPage(
                            member_id: memberId), // Provide the index here
                      ));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '스크랩한 질문',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 여백 크기를 지정합니다
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(height: 16),
            Text(
              '설정',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                // 작성한 글에 대한 동작 처리
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '문의하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                // 댓글 단 글에 대한 동작 처리
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '공지사항',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      // .................... 이 아래부터 .............
      // Text(
      //   user.name ?? '로그인 정보가 없습니다.',
      //   style: TextStyle(
      //     color: Colors.black,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 12,
      //   ),
      // ),.................... 이까지 .............
      // Text(
      //   user.name,
      //   style: TextStyle(
      //     color: Colors.black,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 12,
      //   ),
      // ), .................... 이 아래부터 .............
      // IconButton(
      //   icon: Icon(Icons.image),
      //   onPressed: uploadImageApi.pickImage,
      // ),
      // if (_image != null) Image.file(_image),
      // ElevatedButton(
      //   child: Text('Upload'),
      //   onPressed: uploadImageApi.pickImage,
      // ),
      // // Image.network('$uri${user.profile_image_url}'),
      // IconButton(
      //     icon: Icon(Icons.logout),
      //     onPressed: () async {
      //       await userApi.logoutUser();
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text('로그아웃합니다.')),
      //       );
      //       Navigator.of(context).pushReplacementNamed('/login');
      //     }),
      // IconButton(
      //     icon: Icon(Icons.add_reaction_outlined),
      //     onPressed: () async {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text('태그 목록 확인')),
      //       );
      //       Navigator.pushNamed(context, '/tag');
      //     }),
    ]));
  }
}

Widget getMyPage() {
  return MyPage();
}
