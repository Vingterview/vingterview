import 'package:capston/models/videos.dart';
import 'package:flutter/material.dart';
import '../providers/videos_api.dart';
import '../providers/uploadmp4.dart';
import 'dart:io';
import 'package:capston/models/globals.dart';
import 'package:capston/models/questions.dart';
import 'pick_question.dart';
import 'record_video.dart';
import 'package:image_picker/image_picker.dart';

class EditVideoPage extends StatefulWidget {
  final Videos video; // 수정할 게시글의 객체
  EditVideoPage({@required this.video});

  @override
  _EditVideoPageState createState() => _EditVideoPageState();
}

class _EditVideoPageState extends State<EditVideoPage> {
  int _questionId;
  String _content;
  String _video_url;
  UploadVideoApi uploadVideoApi = UploadVideoApi();
  XFile _video;
  String uri = myUri;
  Questions selectedQuestion;
  String buttonText = "질문을 선택하세요";

  VideoApi _videoApi = VideoApi();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void pickQuestion(BuildContext context) async {
    selectedQuestion = await Navigator.push<Questions>(
        context, MaterialPageRoute(builder: (context) => pick_question()));
    if (selectedQuestion != null) {
      setState(() {
        buttonText = selectedQuestion.questionContent;
        _questionId = selectedQuestion.questionId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.video != null) {
      // 게시글 수정 페이지로 넘어온 경우, 기존 게시글의 값으로 초기화
      setState(() {
        buttonText = widget.video.questionContent;
        _questionId = widget.video.questionId;
        _content = widget.video.content;
        _video_url = widget.video.videoUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6fa8dc), Color(0xFF8A61D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                print(_video);
                if (_formKey.currentState.validate() &&
                    (_video != null || _video_url != null)) {
                  _formKey.currentState.save();
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('글을 수정하는데에 1분~10분 이내에 시간이 소요될 수 있습니다.')));
                    Navigator.pop(context);
                    if (_video != null) {
                      _video_url = await uploadVideoApi.pickVideo(_video);
                      print(_video_url);
                    }
                    print(_video_url);
                    int boardId = await _videoApi.putRequest(
                        widget.video.boardId,
                        _questionId,
                        _content,
                        _video_url);
                    print(boardId);
                  } catch (e) {
                    print("dd$e");
                  }
                }
              },
            ),
          ],
          title: Text(
            '영상 수정하기',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        pickQuestion(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Q. $buttonText",
                          style: TextStyle(
                              fontSize: 16, // 줄글 글씨 크기
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: _content ?? '', // 수정할 게시글의 내용을 초기값으로 설정
                      decoration: InputDecoration(
                        labelText: '본문 내용',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '내용을 작성해주세요';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _content = value;
                      },
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("영상이 선택되었습니다.",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                          children: [
                            IconButton(
                              icon: Icon(Icons.image, color: Colors.black54),
                              onPressed: () async {
                                _video = await uploadVideoApi.returnVideo();
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.camera, color: Colors.black54),
                              onPressed: () async {
                                _video = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => RecordVideoPage(
                                            buttonText:
                                                buttonText.toString())));
                                print(_video);
                                setState(() {});
                                print("dd");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '''빙터뷰 앱의 영상 게시 시 사용자들끼리 불편을 최소화하기 위해 다음과 같은 사항에 유의해야 합니다.

1. 광고 금지: 빙터뷰 앱의 영상 게시에서도 광고는 배제되어야 합니다. 사용자들은 질문이나 내용을 명확히 전달받기 원하므로 광고와 관련된 내용을 포함시키지 않아야 합니다.
2. 명확하고 간결한 설명: 영상 게시 시에는 질문이나 내용에 대한 설명을 명확하고 간결하게 제공해야 합니다. 사용자들이 영상을 시청하고 이해하기 쉽도록 주요 포인트를 강조하고, 필요한 정보를 빠짐없이 전달해야 합니다.
3. 중복 내용 회피: 영상 게시에서도 중복된 내용을 피해야 합니다. 이미 다뤄진 주제나 질문을 반복하지 않고, 다양한 관점과 새로운 정보를 제공하도록 노력해야 합니다.
4. 객관적인 표현 사용: 빙터뷰 앱의 영상 게시에서도 주관적인 표현을 최소화해야 합니다. 객관적이고 중립적인 언어를 사용하여 사용자들이 편안하게 영상을 시청하고 내용을 이해할 수 있도록 도와야 합니다.
5. 예의와 존중: 영상 게시에서도 예의와 존중을 지켜야 합니다. 사용자들은 상호간에 존중받고 예의를 지키는 환경에서 영상을 시청하길 원하므로 무례하거나 공격적인 언어나 태도를 피해야 합니다.
6. 다양성 고려: 빙터뷰 앱의 영상 게시에서도 사용자들의 다양성을 고려해야 합니다. 문화적, 인종적, 성별적 배경을 존중하고 모든 사용자들이 자신을 대표할 수 있는 영상을 제공해야 합니다.
7. 알기 쉬운 표현: 영상 게시에서는 알기 쉬운 표현을 사용해야 합니다. 사용자들이 영상을 시청하고 내용을 쉽게 이해하며 답변할 수 있도록, 전문 용어나 복잡한 언어는 최대한 피해야 합니다.
8. 흥미로운 주제 선택: 영상 게시에서도 사용자들이 흥미를 가질 수 있는 주제를 선택해야 합니다. 흥미로운 주제를 다루고 다양한 관점을 제시하여 사용자들이 영상을 즐기며 응답할 수 있는 환경을 조성해야 합니다.''',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color.fromARGB(255, 176, 169, 169),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
