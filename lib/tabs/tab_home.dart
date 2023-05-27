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
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/web_socket');
            },
            child: Container(
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right_sharp),
                  color: Color(0xFF6fa8dc),
                  onPressed: () {
                    // 수정
                    // Navigator.pushNamed(context, '/video_detail',
                    //     arguments: 1);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right_sharp),
                  color: Color(0xFF6fa8dc),
                  onPressed: () {
                    // // 수정
                    // Navigator.pushNamed(context, '/question');
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
            height: 300,
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
                                  questionList.questions[index].questionContent,
                                  20),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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
    );
  }
}

Widget getHomePage() {
  return HomePage();
}
