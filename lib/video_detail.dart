import 'package:flutter/material.dart';
import '../models/videos.dart';
import '../providers/videos_api.dart';
import '../models/comments.dart';
import '../providers/comments_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';

// 영상 재생할 수 있게 하기 + 댓글 가져오기

class video_detail extends StatelessWidget {
  VideoApi videoApi = VideoApi();
  Videos video;
  CommentApi commentApi = CommentApi();
  List<Comments> commentList;
  int memberId;
  bool isLoading = true;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int index = ModalRoute.of(context).settings.arguments;
    print(index);

    bool _isPlaying = false;

    Future initVideo() async {
      video = await videoApi.getVideoDetail(index);
      commentList = await commentApi.getcomments(0, index); // 게시글로 필터링
      SharedPreferences prefs = await SharedPreferences.getInstance();
      memberId = prefs.getInt('member_id');
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('영상 게시판 글 세부'),
      ),
      body: FutureBuilder<void>(
        future: initVideo(), // Call your initVideo() function
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While fetching data, show a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If an error occurred while fetching data, show an error message
            return Text('Error loading video and comments');
          } else {
            // Once data is fetched, display the video and one comment
            return ListView.builder(
              itemCount: commentList.length +
                  1, // Add 1 for the video details Container
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  // Display video details in the first item
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                      bottom: BorderSide(color: Color(0xFFD9D9D9), width: 1),
                    )),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNXf8crJLB8uSKf9KBauyEfkOC6r4YZWamBRmF4Eu--O3NIOBKaraTEuYRL8fs59ZChKk&usqp=CAU'),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                          margin: EdgeInsets.symmetric(horizontal: 30),
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
                                  text: ' 왜 지원하셨나요?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
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
                                      size: 18, color: Color(0xFFDE50A4)),
                                  SizedBox(width: 5),
                                  Text(video.likeCount.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                              SizedBox(width: 5),
                              Row(
                                children: [
                                  Icon(Icons.comment_outlined,
                                      size: 18, color: Color(0xFF3D85C6)),
                                  SizedBox(width: 5),
                                  Text(video.commentCount.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  // Display comments from commentList
                  Comments comment = commentList[
                      index - 1]; // Subtract 1 to account for video details
                  return Container(
                    padding: EdgeInsets.fromLTRB(
                        10, 5, 10, 10), // Set appropriate margins
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align left
                      children: [
                        Text(
                          comment
                              .memberNickname, // Display userNickname in small letters
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
                            fontSize: 16, // Set slightly larger font size
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.white,
        child: Row(
          children: [
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
                String commentContent = _commentController.text;
                commentApi.postcomment(index, commentContent);
                _commentController.clear();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
