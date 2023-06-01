import 'package:flutter/material.dart';
import 'models/users.dart';
import 'providers/users_api.dart';
import 'mypage/my_videos.dart';
import 'package:capston/mypage/my_comments.dart';

class UserProfilePopup extends StatefulWidget {
  // UserProfilePopup 위젯에 전달할 사용자 정보를 매개변수로 받을 수 있습니다.
  final int userId;

  UserProfilePopup({this.userId});

  @override
  _UserProfilePopupState createState() => _UserProfilePopupState();
}

class _UserProfilePopupState extends State<UserProfilePopup> {
  Users user;
  UserApi userApi = UserApi();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    print(widget.userId);
    Users _user = await userApi.getUserDetail(widget.userId);
    setState(() {
      user = _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '프로필 정보',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 사용자 이미지
          if (user != null)
            Column(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(user.profile_image_url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '닉네임: ${user.nickName}',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                Text(
                  '나이: ${user.age}',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                // SizedBox(height: 16),
                // 추가적인 프로필 정보 항목들...
              ],
            ),
          if (user == null) Text(' '), // 로딩 상태를 보여줄 수도 있습니다.
        ],
      ),
      actions: [
        // "작성글보기" 버튼
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyVideoPage(member_id: user.member_id),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF8A61D4),
          ),
          child: Text(
            '작성글보기',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        // "작성댓글보기" 버튼
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentsPage(member_id: user.member_id),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF8A61D4),
          ),
          child: Text(
            '작성댓글보기',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
