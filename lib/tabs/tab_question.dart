import 'package:flutter/material.dart';
import '../models/questions.dart';
import '../providers/questions_api.dart';
import 'package:capston/question_video.dart';

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
  PageQuestions questionList = PageQuestions(questions: []);
  bool isLoading = false;
  String textData;
  SortingOption _sortingOption = SortingOption.latest;
  DropdownButton<SortingOption> dropdownButton; // Add this variable
  int nextPage = 0;
  bool hasNext = true;
  ScrollController _scrollController = ScrollController();
  bool _isStarred = false;

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
    switch (_sortingOption) {
      case SortingOption.latest:
        PageQuestions _questionList =
            await questionApi.getQuestions(page: nextPage);
        setState(() {
          nextPage = _questionList.nextPage;
          hasNext = _questionList.hasNext;
        });
        print(nextPage);

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
        body: Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '질문 게시판',
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
                    print(questionList.questions.length);
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QVideoPage(
                                question: questionList.questions[index]),
                          ),
                        );
                      },
                      onLongPress: () async {
                        Navigator.pushNamed(context, '/video_write',
                            arguments: questionList.questions[index]);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(8, 3, 20, 8),
                                    child: Text(
                                      textData ??
                                          questionList
                                              .questions[index].questionContent,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      questionApi.scrap(questionList
                                          .questions[index].questionId);
                                      setState(() {
                                        _isStarred = !_isStarred;
                                      });
                                    },
                                    child: Icon(
                                      Icons.star_border,
                                      color: _isStarred
                                          ? Color(0xFF8A61D4)
                                          : Colors.grey,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 4, 8, 0),
                                  child: Text(
                                    questionList.questions[index].tags
                                        .map((tag) => '#${tag.tagName}')
                                        .join(' '),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(
                                        '스크랩 ${questionList.questions[index].scrapCount}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(
                                        '답변 ${questionList.questions[index].boardCount}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
                },
              ))),
    ]));
  }
}
