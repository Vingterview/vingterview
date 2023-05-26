import 'package:flutter/material.dart';
import '[2]game_matched.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Page 1'),
              onPressed: () {
                Navigator.pushNamed(context, '/page1');
              },
            ),
            ElevatedButton(
              child: Text('Page 2'),
              onPressed: () {
                Navigator.pushNamed(context, '/page2');
              },
            ),
            // 다른 페이지로 이동할 수 있는 버튼들을 추가해주세요
          ],
        ),
      ),
    );
  }
}
