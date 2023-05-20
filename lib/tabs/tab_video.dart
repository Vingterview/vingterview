import 'package:flutter/material.dart';

import '../models/videos.dart';
import '../providers/videos_api.dart';
import 'package:capston/video_detail.dart';

Widget getVideoPage() {
  return VideoPage();
}

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

enum SortingOption { latest, like, comment, old }

class _VideoPageState extends State<VideoPage> {
  VideoApi videoApi = VideoApi();
  List<Videos> videoList;
  bool isLoading = true;
  SortingOption _sortingOption = SortingOption.latest;

  Future initVideo() async {
    videoList = await videoApi.getVideos();
    print("init");
  }

  void _updateSortingOption(SortingOption newValue) async {
    setState(() {
      _sortingOption = newValue;
    });
  }

  Future<List<Videos>> _updateWithSorting(SortingOption newValue) async {
    switch (_sortingOption) {
      case SortingOption.latest:
        videoList = await videoApi.getVideos();
        return (videoList);
        break;
      case SortingOption.like:
        videoList = await videoApi.getVideos(query: 3, param: "like");
        return (videoList);
        break;
      case SortingOption.comment:
        videoList = await videoApi.getVideos(query: 3, param: "comment");
        return (videoList);

        break;
      case SortingOption.old:
        videoList = await videoApi.getVideos(query: 3, param: "old");
        return (videoList);
        break;
      default:
        videoList = await videoApi.getVideos();
        return (videoList);
        break;
    }
  }

  Future<void> _refreshPosts() async {
    await _updateWithSorting(_sortingOption);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Videos>>(
      future: _updateWithSorting(_sortingOption),
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
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '영상 게시판',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        value: SortingOption.like,
                        child: Text('좋아요순'),
                      ),
                      DropdownMenuItem(
                        value: SortingOption.comment,
                        child: Text('댓글순'),
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
                    child: ListView.separated(
                      itemCount: videolist.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => video_detail(
                                      index: videolist[index]
                                          .boardId), // Provide the index here
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFD9D9D9), width: 1),
                                borderRadius: BorderRadius.circular(5),
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
                                              videolist[index].memberName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 1),
                                            Text(
                                              videolist[index].createTime,
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
                                        videolist[index].content,
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
                                            text: videolist[index]
                                                .questionContent,
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
                                                size: 18,
                                                color: Color(0xFFDE50A4)),
                                            SizedBox(width: 5),
                                            Text(
                                                videolist[index]
                                                    .likeCount
                                                    .toString(),
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
                                                size: 18,
                                                color: Color(0xFF3D85C6)),
                                            SizedBox(width: 5),
                                            Text(
                                                videolist[index]
                                                    .commentCount
                                                    .toString(),
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
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                    ))),
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
