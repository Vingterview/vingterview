import 'package:capston/mypage/edit_user.dart';
import 'package:capston/screens/screen_index.dart';
import 'package:flutter/material.dart';
import 'video_detail.dart';
import 'video_write.dart';
import 'question_write.dart';
import 'login.dart';
import 'SplashScreen.dart';
import 'pick_question.dart';
import 'pick_tags.dart';
import 'record_video.dart';
import 'login.dart';
import 'video_edit.dart';
import 'package:capston/mypage/my_videos.dart';
import 'package:capston/mypage/edit_user.dart';
import 'websocket/widget/websocket.dart';
import 'websocket/widget/orig.dart';
import 'question_video.dart';

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
      theme: ThemeData(primaryColor: const Color(0xFF8A61D4)),
      routes: {
        '/': (context) => SplashScreen(),
        '/index': (context) => IndexScreen(),
        '/video_detail': (context) => video_detail(),
        '/video_write': (context) => PostVideoPage(),
        '/question_write': (context) => PostQuestionPage(),
        '/question_pick': (context) => pick_question(),
        '/tags_pick': (context) => pick_tags(),
        '/record_video': (context) => RecordVideoPage(),
        '/login': (context) => HomePage(),
        '/video_edit': (context) => EditVideoPage(),
        '/my_videos': (context) => MyVideoPage(),
        '/user_edit': (context) => UserEditPage(),
        '/web_socket': (context) => MyWebSocketApp(),
        '/webso': (context) => oMyWebSocketApp(),
        '/question_video': (context) => QVideoPage(),
      },
      initialRoute: '/',
    );
  }
}