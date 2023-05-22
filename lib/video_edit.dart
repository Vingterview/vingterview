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

  EditVideoPage({this.video});

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
        title: Text('Edit Video'),
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
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              TextFormField(
                initialValue: _content ?? '', // 수정할 게시글의 내용을 초기값으로 설정
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
                  _video = await uploadVideoApi.returnVideo();
                },
              ),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () async {
                  _video = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RecordVideoPage(
                              buttonText: buttonText.toString())));
                  print(_video);
                  print("dd");
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Update Video'), // 수정 버튼 텍스트 변경
                onPressed: () async {
                  if (_formKey.currentState.validate() && _video != null) {
                    _formKey.currentState.save();
                    try {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('영상을 업로드하는데에 1분~10분 이내에 시간이 소요됩니다.')));
                      Navigator.pop(context);
                      _video_url = await uploadVideoApi.pickVideo(_video);
                      print(_video_url);
                      int boardId = await _videoApi.postVideo(
                          _questionId, _content, _video_url);
                      print(boardId);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('영상이 업로드 되었습니다.')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to pick or post video: $e')));
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
