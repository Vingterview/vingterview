import 'package:flutter/material.dart';

import '../tabs/tab_home.dart';
import '../tabs/tab_profile.dart';
import '../tabs/tab_question.dart';
import '../tabs/tab_video.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int selectIndex = 0;
  List<String> namelist = ["홈", "영상 게시판", "질문 게시판", "마이 페이지"];
  final List<Widget> _tabs = [
    getHomePage(),
    getVideoPage(),
    getQuestionPage(),
    getMyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Container(
              margin: EdgeInsets.only(top: 16),
              child: Text(
                namelist[selectIndex],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )),
          centerTitle: true,
          // other app bar properties
        ),
        preferredSize: Size.fromHeight(64),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF3D85C6),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {}),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "홈"),
          BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined), label: "영상게시판"),
          BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page_outlined), label: "질문게시판"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "마이페이지"),
        ],
        selectedItemColor: Color(0xFF3D85C6),
        //unselected된 item color
        unselectedItemColor: Colors.grey,
        //unselected된 label text
        showUnselectedLabels: true,
        //BottomNavigationBar Type -> fixed = bottom item size고정
        //BottomNavigationBar Type -> shifting = bottom item selected 된 item이 확대
        type: BottomNavigationBarType.shifting,
        currentIndex: selectIndex,
        onTap: (idx) {
          setState(() {
            selectIndex = idx;
          });
        },
      ),
      body: _tabs[selectIndex],
    );
  }
}
