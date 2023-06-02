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
import 'package:capston/mypage/my_comments.dart';

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

  Widget _buildImage(String encodedImage, {double width, double height}) {
    if (encodedImage == null || encodedImage.isEmpty) {
      // Display a placeholder image when there is no image
      return Container(
        width: 70,
        height: 70,
        color: Colors.grey, // Or any other UI element to indicate loading
      );
    }

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 3,
          color: Color(0xFF8A61D4),
        ),
      ),
      child: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/logo.png', // Placeholder image asset path
          image: encodedImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while fetching user data
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Show an error message if there was an error fetching user data
            return Text('Error: ${snapshot.error}');
          } else {
            // User data fetched successfully, proceed with building the UI
            return Container(
                child: ListView(children: [
              Container(
                  padding: EdgeInsets.fromLTRB(20, 21, 10, 0),
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
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              _buildImage(user.profile_image_url ??
                                  "https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png"),
                              SizedBox(width: 25),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '닉네임: ${user.nickName}' ?? '닉네임 미등록 사용자',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '나이: ${user.age}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 30), // 여백 크기를 지정합니다
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
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyVideoPage(
                                    member_id:
                                        memberId), // Provide the index here
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
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentsPage(
                                    member_id:
                                        memberId), // Provide the index here
                              ));
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
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScrapQuestionPage(
                                    member_id:
                                        memberId), // Provide the index here
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                        SizedBox(height: 8),
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
        });
  }
}

Widget getMyPage() {
  return MyPage();
}
