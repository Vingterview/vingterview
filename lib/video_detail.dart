import 'package:flutter/material.dart';
import '../models/videos.dart';
import '../providers/videos_api.dart';
import '../models/comments.dart';
import '../providers/comments_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'video_edit.dart';

// 영상 재생할 수 있게 하기 + 댓글 가져오기
class video_detail extends StatefulWidget {
  final int index; // Add index as a constructor parameter

  video_detail({@required this.index});
  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<video_detail> {
  VideoApi videoApi = VideoApi();
  Videos video;
  CommentApi commentApi = CommentApi();
  List<Comments> commentList;
  int memberId;
  bool isLoading = true;
  TextEditingController _commentController = TextEditingController();
  bool isLiked = false; // 글 마다 받아와야 함 <----------------------- 수정 plz
  int likeCount;
  VideoPlayerController _videoController;
  bool isMine = false;
  int commentCount;

  Future<void> _postComment(int index) async {
    String commentContent = _commentController.text;
    await commentApi.postcomment(index, commentContent);
    _commentController.clear();
    print("Dd");
    List<Comments> updatedComments = await commentApi.getcomments(0, index);
    setState(() {
      commentList = updatedComments;
      commentCount = commentList.length;
      print("dddd");
    });
  }

  Future<void> likeVideo(int index) async {
    await videoApi.like(index);
    video = await videoApi.getVideoDetail(index);
    setState(() {
      likeCount = video.likeCount;
    });
  }

  @override
  void initState() {
    super.initState();
    initVideo(); // Initialize the video in initState
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _refreshPost() async {
    video = await videoApi.getVideoDetail(widget.index);
    setState(() {});
  }

  Future<void> initVideo() async {
    final int index = widget.index;
    video = await videoApi.getVideoDetail(index);
    commentList = await commentApi.getcomments(0, index); // 게시글로 필터링
    commentCount = commentList.length;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberId = prefs.getInt('member_id');
    likeCount = video.likeCount;
    if (memberId == video.memberId) {
      isMine = true;
    }

    isMine = true; // <- 수정 삭제용 코드 --------------------------------------------

    _videoController = VideoPlayerController.network(
      'https://vingterview.s3.ap-northeast-2.amazonaws.com/video/2db1f066-4dfc-4c9c-8d1e-1345598f3e97.mp4',
      // '${video.videoUrl}' <------------------------------------------------------------------------- 수정 필요
    );
    await _videoController.initialize().then((_) {
      // Set looping to true here
      _videoController.setLooping(true);
      setState(() {
        isLoading = false;
      });
    });
  }

  void showReportSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1), // 팝업 메시지 표시 시간 설정
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    print(index);

    bool _isPlaying = false;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('영상 게시판 글 세부'),
          actions: isMine
              ? [
                  PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('편집'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('삭제'),
                        ),
                      ];
                    },
                    onSelected: (String value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditVideoPage(video: video)),
                        ).then((value) {
                          initVideo();
                          setState(() {});
                        });
                      } else if (value == 'delete') {
                        videoApi.deleteVideo(index);
                        showReportSnackBar(context, "삭제된 글입니다.");
                        Navigator.pop(context);
                      }
                    },
                  ),
                ]
              : [
                  PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Text('신고하기'),
                        ),
                      ];
                    },
                    onSelected: (String value) {
                      if (value == 'report') {
                        showReportSnackBar(context, "신고되었습니다.");
                      }
                    },
                  ),
                ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  // 게시글을 다시 불러오는 동작을 수행하는 로직을 작성
                  return _refreshPost();
                },
                child: Stack(children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 32),
                      margin: EdgeInsets.only(bottom: 32),
                      // 패딩 설정
                      // margin: EdgeInsets.symmetric(
                      //     horizontal: 20, vertical: 10), // 마진 설정
                      child: ListView.builder(
                        itemCount: commentList.length +
                            1, // Add 1 for the video details Container
                        itemBuilder: (BuildContext context, int idx) {
                          if (idx == 0) {
                            // Display video details in the first item
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                border: BorderDirectional(
                                  bottom: BorderSide(
                                      color: Color(0xFFD9D9D9), width: 1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 20, left: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNXf8crJLB8uSKf9KBauyEfkOC6r4YZWamBRmF4Eu--O3NIOBKaraTEuYRL8fs59ZChKk&usqp=CAU'),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              video.memberName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 1),
                                            Text(
                                              video.createTime,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        video.content,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    width: 300,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEEEEEE),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '   Q.',
                                            style: TextStyle(
                                              color: Color(0xFF3D85C6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextSpan(
                                            text: video.questionContent,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio:
                                        _videoController.value.aspectRatio,
                                    child: VideoPlayer(_videoController),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_videoController.value.isPlaying) {
                                          _videoController.pause();
                                        } else {
                                          _videoController.play();
                                        }
                                      });
                                    },
                                    child: Icon(
                                      _videoController.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.favorite_border_outlined,
                                                size: 18,
                                                color: Color(0xFFDE50A4)),
                                            SizedBox(width: 5),
                                            Text(
                                              likeCount.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.comment_outlined,
                                                size: 18,
                                                color: Color(0xFF3D85C6)),
                                            SizedBox(width: 5),
                                            Text(
                                              commentCount.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () async {
                                            likeVideo(index);
                                            setState(() {
                                              isLiked = !isLiked;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isLiked
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isLiked
                                                      ? Colors.red
                                                      : null,
                                                ),
                                                SizedBox(width: 8),
                                                Text('좋아요'),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (idx == commentList.length + 2) {
                            // Display your additional container at the end
                            return Container(
                                // Additional container
                                // ...
                                );
                          } else {
                            // Display comments from commentList
                            Comments comment = commentList[idx -
                                1]; // Subtract 1 to account for video details
                            return Container(
                              padding: EdgeInsets.fromLTRB(
                                  10, 5, 10, 10), // Set appropriate margins
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // Align left
                                children: [
                                  Text(
                                    comment.memberNickname ??
                                        '비회원 사용자', // Display userNickname in small letters
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          5), // Add space between userNickname and content
                                  Text(
                                    comment.content, // Display comment content
                                    style: TextStyle(
                                      fontSize:
                                          16, // Set slightly larger font size
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      )),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        color: Colors.white,
                        child: Row(children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: '피드백을 작성해주세요!',
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _postComment(index);
                              _commentController.clear();
                              setState(() {});
                            },
                            child: Text('Submit'),
                          ),
                        ]),
                      ))
                ])));
  }
}
