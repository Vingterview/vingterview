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
  bool isBottomSheetOpen = false;

  void _openBottomSheet(BuildContext context) {
    setState(() {
      isBottomSheetOpen = true;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 180,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '글 쓰기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('영상 작성'),
                onTap: () {
                  Navigator.pushNamed(context, '/pick_df');
                },
              ),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('질문 작성'),
                onTap: () {
                  Navigator.pushNamed(context, '/question_write');
                },
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        isBottomSheetOpen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          shadowColor: Colors.white10,
        ),
        // preferredSize: Size.fromHeight(64),
        preferredSize: Size.fromHeight(0),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF8A61D4),
        child: isBottomSheetOpen ? Icon(Icons.close) : Icon(Icons.add),
        onPressed: () async {
          if (isBottomSheetOpen) {
            // Cancel button is pressed
            // Handle cancel action
          } else {
            // Add button is pressed
            _openBottomSheet(context);
          }
        },
      ),
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
        selectedItemColor: Color(0xFF8A61D4),
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
