import 'package:flutter/material.dart';
import '../models/tags.dart';
import '../providers/questions_api.dart';
import 'package:capston/models/globals.dart';
import 'pick_tags.dart';

// import 'package:question_player/question_player.dart';
class PostQuestionPage extends StatefulWidget {
  @override
  _PostquestionPageState createState() => _PostquestionPageState();
}

class _PostquestionPageState extends State<PostQuestionPage> {
  // Define variables for the form fields
  List<Tags> _tags;
  int _memberId;
  String question_content;
  String uri = myUri;
  List<Tags> selectedTags;
  String buttonText = "질문을 선택하세요";

  // Create an instance of the API class
  QuestionApi _questionApi = QuestionApi();

  // Define a form key for validation
  final _formKey = GlobalKey<FormState>();

  // Define a scaffold key for showing snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void pickTags(BuildContext context) async {
    selectedTags = await Navigator.push<List<Tags>>(
        context, MaterialPageRoute(builder: (context) => pick_tags()));
    if (selectedTags != null) {
      // Tags 객체를 전달받으면 처리
      print(selectedTags);
      setState(() {
        // buttonText = selectedTags.; //
        // _questionId = selectedTags.questionId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (preselected != null) {
    //   setState(() {
    //     // 버튼의 텍스트를 선택된 question의 제목으로 변경합니다.
    //     buttonText = preselected.questionContent;
    //     _questionId = preselected.questionId;
    //   });
    // }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Post question'),
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
                  pickTags(context);
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
                  question_content = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Post question'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    try {
                      int questionId = await _questionApi.postQuestion(
                          _tags, question_content);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('question posted with ID $questionId')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to post question: $e')));
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
