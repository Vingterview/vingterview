import 'package:flutter/material.dart';

import '../models/videos.dart';
import '../providers/videos_api.dart';

// class VideoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Text('영상 게시판',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             )));
//   }
// }

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
          return ListView.builder(
            itemCount: videolist.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                  videolist[index].memberName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}