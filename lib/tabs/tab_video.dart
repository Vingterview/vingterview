import 'package:flutter/material.dart';

import '../models/videos.dart';
import '../providers/videos_api.dart';

Widget getVideoPage() {
  return VideoPage();
}

class VideoPage extends StatelessWidget {
  VideoApi videoApi = VideoApi();
  List<Videos> videoList;
  bool isLoading = true;

  Future initVideo() async {
    videoList = await videoApi.getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Videos>>(
      future: videoApi.getVideos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner if the data is not yet available
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if there was an error loading the data
          return Center(child: Text('Error loading Video data'));
        } else {
          // Build the widget tree with the loaded data
          List<Videos> videolist = snapshot.data;
          return Column(children: [
            Expanded(
                child: ListView.builder(
              itemCount: videolist.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () async {
                      Navigator.pushNamed(context, '/video_detail',
                          arguments: videolist[index].boardId);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            videolist[index].memberName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // 작은 글씨 크기
                            ),
                          ),
                          SizedBox(height: 10), // 줄간격을 위한 여백 추가
                          Text(
                            videolist[index].content,
                            style: TextStyle(
                              fontSize: 16, // 줄글 글씨 크기
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            )),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right_sharp),
              color: Color(0xFF6fa8dc),
              onPressed: () {
                Navigator.pushNamed(context, '/video_write');
              },
            ),
          ]);
        }
      },
    );
  }
}
