import 'package:capston/mypage/edit_user.dart';
import 'package:capston/register.dart';
import 'package:capston/screens/screen_index.dart';
import 'package:flutter/material.dart';
import 'video_detail.dart';
import 'video_write.dart';
import 'question_write.dart';
import 'login.dart';
import 'SplashScreen.dart';
import 'tags.dart';
import 'pick_question.dart';
import 'pick_tags.dart';
import 'record_video.dart';
import 'example.dart';
import 'video_edit.dart';
import 'package:capston/mypage/my_videos.dart';
import 'package:capston/mypage/edit_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vingterview',
      routes: {
        '/': (context) => SplashScreen(),
        '/index': (context) => IndexScreen(),
        '/video_detail': (context) => video_detail(),
        '/video_write': (context) => PostVideoPage(),
        '/question_write': (context) => PostQuestionPage(),
        '/login': (context) => login(),
        '/register': (context) => registeruser(),
        '/tag': (context) => tag_detail(),
        '/question_pick': (context) => pick_question(),
        '/tags_pick': (context) => pick_tags(),
        '/record_video': (context) => RecordVideoPage(),
        '/ex': (context) => HomePage(),
        '/video_edit': (context) => EditVideoPage(),
        // '/my_videos': (context) => MyVideoPage(),
        '/user_edit': (context) => UserEditPage(),
      },
      initialRoute: '/',
    );
  }
}
