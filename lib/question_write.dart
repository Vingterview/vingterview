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
  String question_content;
  String uri = myUri;
  List<Tags> selectedTags = [];
  List<String> tagContents;
  String buttonText = "태그를 선택하세요";

  // Create an instance of the API class
  QuestionApi _questionApi = QuestionApi();

  // Define a form key for validation
  final _formKey = GlobalKey<FormState>();

  // Define a scaffold key for showing snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void pickTags(BuildContext context) async {
    selectedTags = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => pick_tags(selectedTags: selectedTags)));
    if (selectedTags != null) {
      // Tags 객체를 전달받으면 처리
      print(selectedTags);
      setState(() {}); // 변경 적용
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
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  try {
                    int questionId = await _questionApi.postQuestion(
                        selectedTags, question_content);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('질문이 등록되었습니다.')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to post question: $e')),
                    );
                  }
                }
              },
            ),
          ],
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
          title: Text(
            '질문 작성하기',
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
                  if (selectedTags != null && selectedTags.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedTags.map((tag) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(175, 218, 210, 224)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            '#${tag.tagName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1A4FB5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  if (selectedTags == null || selectedTags.isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            pickTags(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            margin: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 50),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(175, 218, 210, 224)
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '태그를 선택해주세요',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '질문 내용',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                      ),
                      maxLines: null,
                      minLines: 4,
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
                  ),
                  SizedBox(height: 16),
                  Text(
                    '''빙터뷰 앱의 질문 작성 시 사용자들끼리 불편을 최소화하기 위해 다음과 같은 사항에 유의해야 합니다.

1. 광고 금지: 빙터뷰 앱은 광고가 아니라 질문과 관련된 정보를 제공해야 합니다. 사용자들은 질문 작성란에서 광고를 보기를 원하지 않으므로, 광고와 관련된 내용을 배제해야 합니다.
2. 명확하고 간결한 질문: 사용자들은 질문을 이해하고 쉽게 답변할 수 있도록 질문을 명확하고 간결하게 작성해야 합니다. 복잡하거나 모호한 질문은 혼란을 초래할 수 있으므로 피해야 합니다.
3. 중복 질문 피하기: 사용자들은 중복된 질문을 만나기를 원치 않습니다. 이는 질문 작성 시 이전에 이미 다룬 주제를 피하고, 다양한 관점에서 질문을 작성하는 것을 의미합니다.
4. 주관적인 언어 피하기: 빙터뷰 앱의 질문 작성 시 주관적인 언어를 사용하지 않아야 합니다. 객관적이고 중립적인 질문은 답변자들이 편안하게 응답할 수 있도록 도와줍니다.
5. 예의와 존중: 질문 작성 시 예의와 존중을 지켜야 합니다. 사용자들은 상호간에 존중받고 예의를 지키는 환경을 원하기 때문에 무례하거나 공격적인 질문은 피해야 합니다.
6. 다양성 고려: 빙터뷰 앱의 사용자들은 다양한 문화적, 인종적, 성별적 배경을 가지고 있을 수 있습니다. 질문 작성 시 이러한 다양성을 고려하여 모든 사용자들이 자신을 대표할 수 있는 질문을 작성해야 합니다.
7. 알기 쉬운 언어: 사용자들은 질문을 쉽게 이해하고 답변할 수 있도록 알기 쉬운 언어를 사용해야 합니다. 전문 용어나 복잡한 어구는 최대한 피하고, 일상적이고 이해하기 쉬운 언어를 사용해야 합니다.
8. 적절한 주제 선택: 사용자들은 흥미로운 주제에 대해 더 쉽게 답변할 수 있습니다. 질문 작성 시 사용자들이 흥미를 갖고 응답할 수 있는 주제를 선택하는 것이 중요합니다.''',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color.fromARGB(255, 176, 169, 169),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
