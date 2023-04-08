import 'package:flutter/material.dart';
import '../models/videos.dart';
import '../providers/videos_api.dart';
// import 'package:video_player/video_player.dart';

// 영상 재생할 수 있게 하기 + 댓글 가져오기

class video_detail extends StatelessWidget {
  VideoApi videoApi = VideoApi();
  Videos video;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final int index = ModalRoute.of(context).settings.arguments;

    bool _isPlaying = false;

    Future initVideo() async {
      video = await videoApi.getVideoDetail(index);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Board'),
        ),
        body: FutureBuilder<Videos>(
          future: videoApi.getVideoDetail(index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading spinner if the data is not yet available
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if there was an error loading the data
              return Center(child: Text('Error loading Video data'));
            } else {
              // Build the widget tree with the loaded data
              Videos video = snapshot.data;
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
                child: Text(
                  video.videoUrl,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            }
          },
        ));
  }
}
