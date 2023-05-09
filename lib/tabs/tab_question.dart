import 'package:flutter/material.dart';
import '../models/questions.dart';
import '../providers/questions_api.dart';

Widget getQuestionPage() {
  return QuestionPage();
}

enum SortingOption { latest, scrap, video, old }

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  QuestionApi questionApi = QuestionApi();
  List<Questions> QuestionList;
  bool isLoading = true;
  String textData;
  SortingOption _sortingOption = SortingOption.latest;

  Future initQuestion() async {
    QuestionList = await questionApi.getQuestions();
  }

  void _updateSortingOption(SortingOption newValue) async {
    setState(() {
      _sortingOption = newValue;
    });
  }

  Future<List<Questions>> _updateWithSorting(SortingOption newValue) async {
    switch (_sortingOption) {
      case SortingOption.latest:
        QuestionList = await questionApi.getQuestions();
        return (QuestionList);
        break;
      case SortingOption.scrap:
        QuestionList = await questionApi.getQuestions(query: 4, param: "scrap");
        return (QuestionList);
        break;
      case SortingOption.video:
        QuestionList = await questionApi.getQuestions(query: 4, param: "video");
        return (QuestionList);

        break;
      case SortingOption.old:
        QuestionList = await questionApi.getQuestions(query: 4, param: "old");
        return (QuestionList);
        break;
      default:
        QuestionList = await questionApi.getQuestions();
        return (QuestionList);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Questions>>(
      future: _updateWithSorting(_sortingOption),
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
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '질문 게시판',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<SortingOption>(
                    value: _sortingOption,
                    onChanged: _updateSortingOption,
                    items: [
                      DropdownMenuItem(
                        value: SortingOption.latest,
                        child: Text('최신순'),
                      ),
                      DropdownMenuItem(
                        value: SortingOption.scrap,
                        child: Text('스크랩순'),
                      ),
                      DropdownMenuItem(
                        value: SortingOption.video,
                        child: Text('영상순'),
                      ),
                      DropdownMenuItem(
                        value: SortingOption.old,
                        child: Text('오래된순'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: Questionlist.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    // 이 질문만 모아보기 기능
                    // Navigator.pushNamed(context, '/question_write',
                    //     arguments: Questionlist[index].questionId);
                  },
                  onLongPress: () {
                    // 이 질문으로 글 쓰기 기능
                    // 길게 누르는 이벤트 처리
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
