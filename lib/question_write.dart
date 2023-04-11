import 'package:flutter/material.dart';
import '../models/tags.dart';
import '../providers/questions_api.dart';
import 'package:capston/models/globals.dart';

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

  // Create an instance of the API class
  QuestionApi _questionApi = QuestionApi();

  // Define a form key for validation
  final _formKey = GlobalKey<FormState>();

  // Define a scaffold key for showing snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Member ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a member ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _memberId = int.parse(value);
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
                          _tags, _memberId, question_content);
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
