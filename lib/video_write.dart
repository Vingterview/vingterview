import 'package:flutter/material.dart';
import '../providers/videos_api.dart';
import '../providers/uploadmp4.dart';
import 'dart:io';
import 'package:capston/models/globals.dart';
import 'package:capston/models/questions.dart';
import 'pick_question.dart';
import 'record_video.dart';

// import 'package:video_player/video_player.dart';
class PostVideoPage extends StatefulWidget {
  @override
  _PostVideoPageState createState() => _PostVideoPageState();
}

class _PostVideoPageState extends State<PostVideoPage> {
  // Define variables for the form fields

  int _questionId;
  String _content;
  String _video_url;
  UploadVideoApi uploadVideoApi = UploadVideoApi();
  File _video;
  String uri = myUri;
  Questions selectedQuestion;
  String buttonText = "질문을 선택하세요";

  // Create an instance of the API class
  VideoApi _videoApi = VideoApi();

  // Define a form key for validation
  final _formKey = GlobalKey<FormState>();

  // Define a scaffold key for showing snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void pickQuestion(BuildContext context) async {
    selectedQuestion = await Navigator.push<Questions>(
        context, MaterialPageRoute(builder: (context) => pick_question()));
    if (selectedQuestion != null) {
      // question 객체를 전달받으면 처리
      print(selectedQuestion.questionId);
      setState(() {
        buttonText = selectedQuestion.questionContent;
        _questionId = selectedQuestion.questionId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Questions preselected = ModalRoute.of(context).settings.arguments;

    if (preselected != null) {
      setState(() {
        // 버튼의 텍스트를 선택된 question의 제목으로 변경합니다.
        buttonText = preselected.questionContent;
        _questionId = preselected.questionId;
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Post Video'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () async {
                  pickQuestion(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 16, // 줄글 글씨 크기
                    ),
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value;
                },
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () async {
                  _video_url = await uploadVideoApi.pickVideo();
                  print(_video_url);
                },
              ),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () async {
                  _video_url = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RecordVideoPage(
                              buttonText: buttonText.toString())));
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Post Video'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    try {
                      int boardId = await _videoApi.postVideo(
                          _questionId, _content, _video_url);
                      print(boardId);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Video posted with ID $boardId')));
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to post video: $e')));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
