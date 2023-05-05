import 'package:flutter/material.dart';
import '../models/questions.dart';
import '../providers/questions_api.dart';

Widget getQuestionPage() {
  return QuestionPage();
}

class QuestionPage extends StatelessWidget {
  QuestionApi questionApi = QuestionApi();
  List<Questions> QuestionList;
  bool isLoading = true;
  String textData;

  Future initQuestion() async {
    QuestionList = await questionApi.getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Questions>>(
      future: questionApi.getQuestions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner if the data is not yet available
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if there was an error loading the data
          return Center(child: Text('Error loading Question data'));
        } else {
          // Build the widget tree with the loaded data
          List<Questions> Questionlist = snapshot.data;
          return Column(children: [
            Expanded(
                child: ListView.builder(
              itemCount: Questionlist.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, '/video_write',
                        arguments: Questionlist[index].questionId);
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
                      textData ?? Questionlist[index].questionContent,
                      style: TextStyle(
                        fontSize: 16, // 줄글 글씨 크기
                      ),
                    ),
                  ),
                );
              },
            )),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right_sharp),
              color: Color(0xFF6fa8dc),
              onPressed: () {
                Navigator.pushNamed(context, '/question_write');
              },
            ),
          ]);
        }
      },
    );
  }
}
