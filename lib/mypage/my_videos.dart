import 'package:flutter/material.dart';

import '../models/videos.dart';
import '../providers/videos_api.dart';
import 'package:capston/video_detail.dart';

Widget getMyVideoPage() {
  return MyVideoPage();
}

class MyVideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

enum SortingOption { latest, like, comment, old }

class _VideoPageState extends State<MyVideoPage> {
  VideoApi videoApi = VideoApi();
  List<Videos> videoList = [];
  bool isLoading = true;
  SortingOption _sortingOption = SortingOption.latest;
  int member_id;

  Future<void> initVideo() async {
    videoList = await videoApi.getVideos();
    print("init");
  }

  void _updateSortingOption(SortingOption newValue) {
    setState(() {
      _sortingOption = newValue;
    });
    _refreshPosts();
  }

  Future<List<Videos>> _updateWithSorting(
      SortingOption newValue, int member_id) async {
    member_id = 0;
    switch (newValue) {
      case SortingOption.latest:
        videoList =
            await videoApi.getVideos(query: 1, param: member_id.toString());
        break;
      case SortingOption.like:
        videoList =
            await videoApi.getVideos(query: 2, param: member_id.toString());
        break;
      case SortingOption.comment:
        videoList =
            await videoApi.getVideos(query: 3, param: member_id.toString());
        break;
      case SortingOption.old:
        videoList =
            await videoApi.getVideos(query: 4, param: member_id.toString());
        break;
      default:
        videoList = await videoApi.getVideos();
        break;
    }
    return videoList;
  }

  Future<void> _refreshPosts() async {
    await _updateWithSorting(_sortingOption, member_id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  Widget build(BuildContext context) {
    member_id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('작성한 글'),
        ),
        body: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '작성한 글',
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
              onRefresh: _refreshPosts,
              child: ListView.separated(
                itemCount: videoList.length > 0 ? videoList.length : 1,
                itemBuilder: (context, index) {
                  if (videoList.length > 0) {
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => video_detail(
                              index: videoList[index].boardId,
                            ),
                          ),
                        );
                        _updateWithSorting(_sortingOption, member_id);
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFD9D9D9), width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
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
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNXf8crJLB8uSKf9KBauyEfkOC6r4YZWamBRmF4Eu--O3NIOBKaraTEuYRL8fs59ZChKk&usqp=CAU',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        videoList[index].memberName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        videoList[index].createTime,
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
                                  videoList[index].content,
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
                                      text: videoList[index].questionContent,
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
                                      Icon(
                                        Icons.favorite_border_outlined,
                                        size: 18,
                                        color: Color(0xFFDE50A4),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        videoList[index].likeCount.toString(),
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
                                      Icon(
                                        Icons.comment_outlined,
                                        size: 18,
                                        color: Color(0xFF3D85C6),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        videoList[index]
                                            .commentCount
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
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
                        '작성한 글이 없습니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10);
                },
              ),
            ),
          )
        ]));
  }
}
