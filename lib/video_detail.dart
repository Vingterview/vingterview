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
                    child: Column(
                      children: [
                        Text(
                          video.videoUrl,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          video.content,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
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
