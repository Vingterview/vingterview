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
      },
      initialRoute: '/',
    );
  }
}
