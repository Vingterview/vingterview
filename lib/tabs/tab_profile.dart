import 'package:flutter/material.dart';
import 'dart:io';
import '../models/users.dart';
import '../providers/users_api.dart';
import '../providers/uploadImg.dart';
import '../providers/uploadmp4.dart';
import 'package:capston/models/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatelessWidget {
  UserApi userApi = UserApi();
  Users user;
  bool isLoading = true;
  UploadImageApi uploadImageApi = UploadImageApi();
  UploadVideoApi uploadVideoApi = UploadVideoApi();
  File _image;
  String uri = myUri;

  Future initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int memberId = prefs.getInt('member_id'); // 'member_id'라는 키로 저장한 값 가져오기
    if (memberId != null) {
      user = await userApi.getUserDetail(memberId);
    } else {
      user = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: userApi.getUserDetail(1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner if the data is not yet available
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if there was an error loading the data
          return Center(child: Text('Error loading user data'));
        } else {
          // Build the widget tree with the loaded data
          Users user = snapshot.data;
          return Container(
              child: ListView(children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        // 작성한 글에 대한 동작 처리
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
                          '댓글 단 글',
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
                        // 좋아요한 글에 대한 동작 처리
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '좋아요한 글',
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
                        // 스크랩한 질문에 대한 동작 처리
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
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            Container(
              color: Colors.purple, // 박스의 배경색
              padding: EdgeInsets.all(16), // 안쪽 여백 설정
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // 수평축에서 어디에 맞출지 설정
                children: [
                  Text(
                    // 제목
                    '설정',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16), // 제목과 내용 사이 여백
                  ElevatedButton(
                    // 문의하기 버튼
                    onPressed: () {},
                    child: Text('문의하기'),
                  ),
                  SizedBox(height: 16), // 버튼과 버튼 사이 여백
                  ElevatedButton(
                    // 공지사항 버튼
                    onPressed: () {},
                    child: Text('공지사항'),
                  ),
                ],
              ),
            ),

            Text(
              user.name ?? '로그인 정보가 없습니다.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            // Text(
            //   user.name,
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 12,
            //   ),
            // ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: uploadImageApi.pickImage,
            ),
            if (_image != null) Image.file(_image),
            ElevatedButton(
              child: Text('Upload'),
              onPressed: uploadImageApi.pickImage,
            ),
            // Image.network('$uri${user.profile_image_url}'),
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await userApi.logoutUser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('로그아웃합니다.')),
                  );
                  Navigator.of(context).pushReplacementNamed('/login');
                }),
            IconButton(
                icon: Icon(Icons.add_reaction_outlined),
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('태그 목록 확인')),
                  );
                  Navigator.pushNamed(context, '/tag');
                }),
          ]));
        }
      },
    );
  }
}

Widget getMyPage() {
  return MyPage();
}
