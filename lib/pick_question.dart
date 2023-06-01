import 'package:flutter/material.dart';
import '../models/questions.dart';
import '../providers/questions_api.dart';

enum SortingOption { latest, scrap, video, old }

class pick_question extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<pick_question> {
  QuestionApi questionApi = QuestionApi();
  PageQuestions questionList = PageQuestions(questions: []);
  bool isLoading = false;
  String textData;
  SortingOption _sortingOption = SortingOption.latest;
  DropdownButton<SortingOption> dropdownButton; // Add this variable
  int nextPage = 0;
  bool hasNext = true;
  ScrollController _scrollController = ScrollController();

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
      print("ddd??");
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    print("로드모어 진입");
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
    setState(() {});
  }

  Future<PageQuestions> _updateWithSorting(
      SortingOption newValue, int nextPage) async {
    switch (_sortingOption) {
      case SortingOption.latest:
        PageQuestions _questionList =
            await questionApi.getQuestions(page: nextPage);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });

        return (_questionList);
        break;
      case SortingOption.scrap:
        PageQuestions _questionList = await questionApi.getQuestions(
            query: 4, param: "scrap", page: nextPage);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });

        return (_questionList);
        break;
      case SortingOption.video:
        PageQuestions _questionList = await questionApi.getQuestions(
            query: 4, param: "video", page: nextPage);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });

        return (_questionList);
        break;
      case SortingOption.old:
        PageQuestions _questionList = await questionApi.getQuestions(
            query: 4, param: "old", page: nextPage);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });

        return (_questionList);
        break;
      default:
        PageQuestions _questionList =
            await questionApi.getQuestions(page: nextPage);
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
          title: Text(
            '질문 선택',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '질문 선택',
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
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: questionList.questions.length + 1,
                    itemBuilder: (context, index) {
                      if (index < questionList.questions.length) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(
                                context, questionList.questions[index]);
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
                                  "Q. ${questionList.questions[index].questionContent}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else if (hasNext) {
                        return Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )))
        ]));
  }
}