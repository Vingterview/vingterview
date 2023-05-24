import 'package:flutter/material.dart';
import 'models/users.dart';
import 'providers/users_api.dart';

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
    user = await userApi.getUserDetail(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('프로필 정보'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 프로필 정보 표시
          Text('이름: ${user.nickName}'),
          Text('나이: ${user.age}'),
          // 추가적인 프로필 정보 항목들...
        ],
      ),
      actions: [
        // "작성글보기" 버튼
        TextButton(
          onPressed: () {
            // 작성글보기 버튼이 눌렸을 때 처리 로직
            // 해당 사용자의 작성글 화면으로 이동하도록 구현
          },
          child: Text('작성글보기'),
        ),
        // "작성댓글보기" 버튼
        TextButton(
          onPressed: () {
            // 작성댓글보기 버튼이 눌렸을 때 처리 로직
            // 해당 사용자의 작성댓글 화면으로 이동하도록 구현
          },
          child: Text('작성댓글보기'),
        ),
      ],
    );
  }
}
