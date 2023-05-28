import 'package:flutter/material.dart';
import '../models/videos.dart';
import '../providers/videos_api.dart';
import '../models/questions.dart';
import '../providers/questions_api.dart';
import 'package:capston/video_detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoApi videoApi = VideoApi();
  PageVideos videoList = PageVideos(videos: []);
  bool isLoadingVideos = false;
  QuestionApi questionApi = QuestionApi();
  PageQuestions questionList = PageQuestions(questions: []);
  bool isLoadingQuestions = false;

  Future<void> _getVideos() async {
    setState(() {
      isLoadingVideos = true;
    });
    PageVideos _videoList = await videoApi.getVideos(
      query: 0,
    );
    setState(() {
      videoList = _videoList;
      isLoadingVideos = false;
    });
  }

  Future<void> _getQuestions() async {
    setState(() {
      isLoadingQuestions = true;
    });
    PageQuestions _questionList = await questionApi.getQuestions(
      query: 0,
    );
    setState(() {
      questionList = _questionList;
      isLoadingQuestions = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getVideos();
    _getQuestions();
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(),
          preferredSize: Size.fromHeight(0),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.fromLTRB(20, 1, 20, 8),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(
                  '면접 연습은 빙터뷰에서!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: Text(
                  '아래 버튼 누르고 모의 면접하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/web_socket');
                },
                child: Container(
                  width: double.infinity,
                  height: 220,
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1A4FB5),
                        Color(0xB2B068DF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '다양한 질문들을 실시간으로 대처해보자!',
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(
                  '빙터뷰 취준 커뮤니티',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: Text(
                  '커뮤니티에서 정보 공유하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(36, 8, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '영상 게시판',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right_sharp),
                      color: Color(0xFF8A61D4),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 16),
                height: 190,
                child: isLoadingVideos
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: videoList.videos.length > 5
                            ? 5
                            : videoList.videos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => video_detail(
                                    index: videoList.videos[index].boardId,
                                  ), // Provide the index here
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  _truncateText(
                                      videoList.videos[index].content, 20),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(36, 0, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '질문 게시판',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right_sharp),
                      color: Color(0xFF8A61D4),
                      onPressed: () {
                        // // 수정
                        // Navigator.pushNamed(context, '/question');
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 16),
                height: 190,
                child: isLoadingQuestions
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: questionList.questions.length > 5
                            ? 5
                            : questionList.questions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/video_write',
                                  arguments: questionList.questions[index]);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  _truncateText(
                                      questionList
                                          .questions[index].questionContent,
                                      20),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }
}

Widget getHomePage() {
  return HomePage();
}
