import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectIndex = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Container(
              margin: EdgeInsets.only(top: 12),
              child: Text(
                '홈',
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
      body: getPage(),
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
    );
  }

  Widget getPage() {
    if (selectIndex == 0) {
      return getHomePage();
    } else if (selectIndex == 1) {
      return getVideoPage();
    } else if (selectIndex == 2) {
      return getQuestionPage();
    } else {
      return getMyPage();
    }
  }

  Widget getHomePage() {
    return Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFF6fa8dc),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '실시간 면접 참여',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '다양한 질문으로 실시간으로 대처해보자!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 120,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
              decoration: BoxDecoration(
                color: Color(0xFFde72b2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '핫한 질문 확인하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '면접 준비 필수 질문은?!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '영상 게시판',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right_sharp),
                    color: Color(0xFF6fa8dc),
                    onPressed: () {
                      setState(() {
                        selectIndex = 1;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
              height: 300,
              color: Colors.orange,
              child: Center(
                child: Text('Container 4'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '질문 게시판',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right_sharp),
                    color: Color(0xFF6fa8dc),
                    onPressed: () {
                      setState(() {
                        selectIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
              height: 300,
              color: Colors.yellow,
              child: Center(
                child: Text('Container 6'),
              ),
            ),
          ],
        ));
  }

  Widget getVideoPage() {
    return Container(
        child: Text('영상 게시판',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            )));
  }

  Widget getQuestionPage() {
    return Container(
        child: Text('질문 게시판',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            )));
  }

  Widget getMyPage() {
    return Container(
        child: Text('마이 페이지',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            )));
  }
}
