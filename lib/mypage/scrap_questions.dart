import 'package:flutter/material.dart';
import '../models/questions.dart';
import '../providers/questions_api.dart';

Widget getQuestionPage() {
  return ScrapQuestionPage();
}

enum SortingOption { latest, scrap, video, old }

class ScrapQuestionPage extends StatefulWidget {
  final int member_id;
  ScrapQuestionPage({@required this.member_id});
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<ScrapQuestionPage> {
  QuestionApi questionApi = QuestionApi();
  PageQuestions questionList = PageQuestions(questions: []);
  bool isLoading = false;
  String textData;
  SortingOption _sortingOption = SortingOption.latest;
  DropdownButton<SortingOption> dropdownButton; // Add this variable
  int nextPage = 0;
  bool hasNext = true;
  ScrollController _scrollController = ScrollController();
  int member_id;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    initializeDataList();
  }

  Future<void> initializeDataList() async {
    // 비동기 함수를 사용하여 초기 데이터를 가져옵니다.
    nextPage = 0;
    hasNext = true;
    PageQuestions newPage = await _updateWithSorting(_sortingOption, nextPage);

    setState(() {
      questionList.questions = newPage.questions;
      nextPage = newPage.nextPage;
      hasNext = newPage.hasNext;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the bottom of the scroll view
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    print("로드모어");
    if (!hasNext) {
      return;
    }

    PageQuestions newPage = await _updateWithSorting(_sortingOption, nextPage);

    setState(() {
      List<Questions> tempList = List.from(questionList.questions);
      print(tempList.length);
      tempList.addAll(newPage.questions);
      print(tempList.length);
      questionList.questions = tempList;
      nextPage = newPage.nextPage;
      hasNext = newPage.hasNext; // 로딩 상태를 false로 설정합니다.
      isLoading = false;
      print(questionList.questions.length);
    });
  }

  void _updateSortingOption(SortingOption newValue) async {
    setState(() {
      _sortingOption = newValue;
    });
    await initializeDataList();
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _refreshPosts() async {
    initializeDataList();
  }

  Future<PageQuestions> _updateWithSorting(
      SortingOption newValue, int nextPage) async {
    print("소팅 함수");
    member_id = widget.member_id;
    switch (_sortingOption) {
      case SortingOption.latest:
        PageQuestions _questionList = await questionApi.getQuestions(
            page: nextPage, sort: "&scrap_member_id=$member_id");
        if (_questionList == null) return PageQuestions(questions: []);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });
        print(nextPage);

        return (_questionList);
        break;
      case SortingOption.scrap:
        PageQuestions _questionList = await questionApi.getQuestions(
            query: 4,
            param: "scrap",
            page: nextPage,
            sort: "&scrap_member_id=$member_id");
        if (_questionList == null) return PageQuestions(questions: []);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });

        return (_questionList);
        break;
      case SortingOption.video:
        PageQuestions _questionList = await questionApi.getQuestions(
            query: 4,
            param: "video",
            page: nextPage,
            sort: "&scrap_member_id=$member_id");
        if (_questionList == null) return PageQuestions(questions: []);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });

        return (_questionList);
        break;
      case SortingOption.old:
        PageQuestions _questionList = await questionApi.getQuestions(
            query: 4,
            param: "old",
            page: nextPage,
            sort: "&scrap_member_id=$member_id");
        if (_questionList == null) return PageQuestions(questions: []);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });

        return (_questionList);
        break;
      default:
        PageQuestions _questionList = await questionApi.getQuestions(
            page: nextPage, sort: "&scrap_member_id=$member_id");
        if (_questionList == null) return PageQuestions(questions: []);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });

        return (_questionList);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '스크랩한 질문',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            dropdownButton = DropdownButton<SortingOption>(
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
          child: RefreshIndicator(
              onRefresh: () {
                // 게시글을 다시 불러오는 동작을 수행하는 로직을 작성
                return _refreshPosts();
              },
              child: ListView.separated(
                controller: _scrollController,
                itemCount: questionList.questions.length + 1 > 1
                    ? questionList.questions.length
                    : 1,
                itemBuilder: (context, index) {
                  if (questionList.questions.length > 0) {
                    print(questionList.questions.length);
                    if (index < questionList.questions.length) {
                      return GestureDetector(
                        onTap: () async {
                          // 이 질문만 모아보기 기능
                          // Navigator.pushNamed(context, '/question_write',
                          //     arguments: Questionlist[index].questionId);
                        },
                        onLongPress: () async {
                          Navigator.pushNamed(context, '/video_write',
                              arguments: questionList.questions[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
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
                            textData ??
                                questionList.questions[index].questionContent,
                            style: TextStyle(
                              fontSize: 16, // 줄글 글씨 크기
                            ),
                          ),
                        ),
                      );
                    } else if (hasNext) {
                      print(questionList.questions.length);
                      return Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      print(questionList.questions.length);
                      return Container();
                    }
                  } else {
                    // 리스트가 비어있을 경우
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '스크랩한 질문이 없습니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10);
                },
              ))),
    ]));
  }
}