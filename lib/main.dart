import 'package:capston/screens/screen_index.dart';
import 'package:flutter/material.dart';
import 'tabs/tab_question.dart';
import 'tabs/tab_video.dart';
import 'board.dart';

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
        '/index': (context) => IndexScreen(),
        '/board': (context) => Board(),
      },
      initialRoute: '/index',
    );
  }
}
