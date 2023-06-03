import 'package:flutter/material.dart';
import '../models/questions.dart';
import '../providers/questions_api.dart';
import 'package:capston/question_video.dart';
import '../models/tags.dart';

enum SortingOption { latest, scrap, video, old }

class tQuestionPage extends StatefulWidget {
  final List<Tags> selectedTags;
  tQuestionPage({@required this.selectedTags});
  @override
  _tQuestionPageState createState() =>
      _tQuestionPageState(selectedTags: selectedTags);
}

class _tQuestionPageState extends State<tQuestionPage> {
  List<Tags> selectedTags = [];
  _tQuestionPageState({@required this.selectedTags});
  QuestionApi questionApi = QuestionApi();
  PageQuestions questionList = PageQuestions(questions: []);
  bool isLoading = false;
  String textData;
  SortingOption _sortingOption = SortingOption.latest;
  int nextPage = 0;
  bool hasNext = true;
  ScrollController _scrollController = ScrollController();
  List<bool> _isStarredList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    initializeDataList();
  }

  Future<void> initializeDataList() async {
    nextPage = 0;
    hasNext = true;
    PageQuestions newPage = await _updateWithSorting(_sortingOption, nextPage);

    setState(() {
      questionList.questions = newPage.questions;
      nextPage = newPage.nextPage;
      hasNext = newPage.hasNext;
      _isStarredList.addAll(List.filled(newPage.questions.length, false));
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
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    if (!hasNext) {
      return;
    }

    PageQuestions newPage = await _updateWithSorting(_sortingOption, nextPage);

    setState(() {
      List<Questions> tempList = List.from(questionList.questions);
      tempList.addAll(newPage.questions);
      questionList.questions = tempList;
      nextPage = newPage.nextPage;
      hasNext = newPage.hasNext;
      _isStarredList.addAll(List.filled(newPage.questions.length, false));
      isLoading = false;
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
    PageQuestions _questionList;
    String _sort = "&tag_id=${widget.selectedTags.last.tagId}";

    switch (_sortingOption) {
      case SortingOption.latest:
        _questionList =
            await questionApi.getQuestions(page: nextPage, sort: _sort);
        break;
      case SortingOption.scrap:
        _questionList = await questionApi.getQuestions(
            query: 4, param: "scrap", page: nextPage, sort: _sort);
        break;
      case SortingOption.video:
        _questionList = await questionApi.getQuestions(
            query: 4, param: "video", page: nextPage, sort: _sort);
        break;
      case SortingOption.old:
        _questionList = await questionApi.getQuestions(
            query: 4, param: "old", page: nextPage, sort: _sort);
        break;
      default:
        _questionList =
            await questionApi.getQuestions(page: nextPage, sort: _sort);
        break;
    }

    setState(() {
      nextPage = _questionList.nextPage;
      hasNext = _questionList.hasNext;
    });

    return _questionList;
  }

  @override
  Widget build(BuildContext context) {
    List<int> selectedTagId = [];
    for (var tag in widget.selectedTags) {
      selectedTagId.add(tag.tagId);
    }
    print(selectedTagId);

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
          '태그별 질문 보기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    for (var tag in widget.selectedTags)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        margin: EdgeInsets.symmetric(horizontal: 4),
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
                      ),
                  ],
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
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: questionList.questions.length + 1,
                itemBuilder: (context, index) {
                  if (index < questionList.questions.length) {
                    Questions question = questionList.questions[index];
                    bool isStarred = _isStarredList[index];

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QVideoPage(question: question),
                          ),
                        );
                      },
                      onLongPress: () async {
                        Navigator.pushNamed(context, '/video_write',
                            arguments: question);
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
                                      textData ?? question.questionContent,
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
                                      questionApi.scrap(question.questionId);
                                      setState(() {
                                        _isStarredList[index] = !isStarred;
                                      });
                                    },
                                    child: Icon(
                                      Icons.star_border,
                                      color: isStarred
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
                                Row(children: [
                                  for (var tag in question.tags)
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 4, 4, 0),
                                      child: Text(
                                        '#${tag.tagName}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: selectedTagId
                                                    .contains(tag.tagId)
                                                ? Color(0xFF8A61D4)
                                                : Colors.grey,
                                            fontWeight: selectedTagId
                                                    .contains(tag.tagId)
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      ),
                                    ),
                                ]),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(
                                        '스크랩 ${question.scrapCount}',
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
                                        '답변 ${question.boardCount}',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
