import 'package:flutter/material.dart';
import '../providers/videos_api.dart';
import '../providers/uploadmp4.dart';
import 'dart:io';
import 'package:capston/models/globals.dart';

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

  // Create an instance of the API class
  VideoApi _videoApi = VideoApi();

  // Define a form key for validation
  final _formKey = GlobalKey<FormState>();

  // Define a scaffold key for showing snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Question ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a question ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _questionId = int.parse(value);
                },
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
