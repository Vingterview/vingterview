import 'package:flutter/material.dart';
import '../models/comments.dart';
import '../providers/comments_api.dart';
import '../providers/videos_api.dart';
import 'package:capston/video_detail.dart';

Widget getCommentsPage() {
  return CommentsPage();
}

class CommentsPage extends StatefulWidget {
  final int member_id;
  CommentsPage({@required this.member_id});
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  CommentApi commentApi = CommentApi();
  List<Comments> commentsList = [];
  bool isLoading = false;
  String textData;
  int member_id;

  @override
  void initState() {
    super.initState();
    initializeDataList();
  }

  Future<void> initializeDataList() async {
    // 비동기 함수를 사용하여 초기 데이터를 가져옵니다.
    member_id = widget.member_id;
    List<Comments> _commentsList = await commentApi.getcomments(1, member_id);

    setState(() {
      commentsList = _commentsList;
    });
  }

  Future<void> _refreshPosts() async {
    initializeDataList();
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
            '작성한 댓글',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () {
                    // 게시글을 다시 불러오는 동작을 수행하는 로직을 작성
                    return _refreshPosts();
                  },
                  child: ListView.separated(
                    itemCount:
                        commentsList.length > 0 ? commentsList.length : 1,
                    itemBuilder: (context, index) {
                      if (commentsList.length > 0) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => video_detail(
                                  index: commentsList[index].boardId,
                                ), // Provide the index here
                              ),
                            );
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
                              textData ?? commentsList[index].content,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                // 줄글 글씨 크기
                              ),
                            ),
                          ),
                        );
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
                            '작성한 댓글이 없습니다.',
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
