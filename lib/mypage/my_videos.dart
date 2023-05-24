import 'package:flutter/material.dart';

import '../models/videos.dart';
import '../providers/videos_api.dart';
import 'package:capston/video_detail.dart';
import 'package:capston/user_popup.dart';

Widget getMyVideoPage() {
  return MyVideoPage();
}

class MyVideoPage extends StatefulWidget {
  final int member_id;
  MyVideoPage({@required this.member_id});
  @override
  _VideoPageState createState() => _VideoPageState();
}

enum SortingOption { latest, like, comment, old }

class _VideoPageState extends State<MyVideoPage> {
  VideoApi videoApi = VideoApi();
  PageVideos videoList = PageVideos(videos: []);
  bool isLoading = false;
  SortingOption _sortingOption = SortingOption.latest;
  DropdownButton<SortingOption> dropdownButton; // Add this variable
  int nextPage = 0;
  bool hasNext = true;
  ScrollController _scrollController = ScrollController();
  int member_id;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    initializeDataList();
  }

  Future<void> initializeDataList() async {
    // 비동기 함수를 사용하여 초기 데이터를 가져옵니다.
    nextPage = 0;
    hasNext = true;
    PageVideos newPage = await _updateWithSorting(_sortingOption, nextPage);

    setState(() {
      member_id = widget.member_id;
      videoList.videos = newPage.videos;
      nextPage = newPage.nextPage;
      hasNext = newPage.hasNext;
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
      // Reached the bottom of the scroll view
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    print("로드모어");
    if (!hasNext) {
      return;
    }

    PageVideos newPage = await _updateWithSorting(_sortingOption, nextPage);

    setState(() {
      List<Videos> tempList = List.from(videoList.videos);
      print(tempList.length);
      tempList.addAll(newPage.videos);
      print(tempList.length);
      videoList.videos = tempList;
      nextPage = newPage.nextPage;
      hasNext = newPage.hasNext; // 로딩 상태를 false로 설정합니다.
      isLoading = false;
      print(videoList.videos.length);
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

  Future<PageVideos> _updateWithSorting(
      SortingOption newValue, int nextPage) async {
    print("소팅함수");
    member_id = widget.member_id;
    switch (_sortingOption) {
      case SortingOption.latest:
        PageVideos _videoList = await videoApi.getVideos(
            page: nextPage, sort: "&member_id=$member_id");
        if (_videoList == null) return PageVideos(videos: []); // 작성한 글 없음
        setState(() {
          nextPage = _videoList.nextPage;
          hasNext = _videoList.hasNext;
        });
        return (_videoList);
        break;
      case SortingOption.like:
        PageVideos _videoList = await videoApi.getVideos(
            query: 3,
            param: "like",
            page: nextPage,
            sort: "&member_id=$member_id");
        if (_videoList == null) return PageVideos(videos: []);
        setState(() {
          nextPage = _videoList.nextPage;
          hasNext = _videoList.hasNext;
        });
        return (_videoList);
        break;
      case SortingOption.comment:
        PageVideos _videoList = await videoApi.getVideos(
            query: 3,
            param: "comment",
            page: nextPage,
            sort: "&member_id=$member_id");
        if (_videoList == null) return PageVideos(videos: []);
        setState(() {
          nextPage = _videoList.nextPage;
          hasNext = _videoList.hasNext;
        });
        return (_videoList);

        break;
      case SortingOption.old:
        PageVideos _videoList = await videoApi.getVideos(
            query: 3,
            param: "old",
            page: nextPage,
            sort: "&member_id=$member_id");
        if (_videoList == null) return PageVideos(videos: []);
        setState(() {
          nextPage = _videoList.nextPage;
          hasNext = _videoList.hasNext;
        });
        return (_videoList);
        break;
      default:
        PageVideos _videoList = await videoApi.getVideos(
            page: nextPage, sort: "&member_id=$member_id");
        if (_videoList == null) return PageVideos(videos: []);
        setState(() {
          nextPage = _videoList.nextPage;
          hasNext = _videoList.hasNext;
        });
        return (_videoList);
        break;
    }
  }

  Future<void> _refreshPosts() async {
    initializeDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '작성한 글',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                dropdownButton = DropdownButton<SortingOption>(
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
                controller: _scrollController,
                itemCount: videoList.videos.length + 1 > 1
                    ? videoList.videos.length
                    : 1,
                itemBuilder: (context, index) {
                  if (videoList.videos.length > 0) {
                    if (index < videoList.videos.length) {
                      return GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => video_detail(
                                index: videoList.videos[index].boardId,
                              ), // Provide the index here
                            ),
                          ).then((value) {
                            _updateWithSorting(_sortingOption, nextPage);
                            setState(() {});
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFD9D9D9),
                              width: 1,
                            ),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Stack(
                                                    children: [
                                                      // 배경 어둠 효과
                                                      ModalBarrier(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                      // 팝업 창
                                                      UserProfilePopup(
                                                          userId: videoList
                                                              .videos[index]
                                                              .memberId),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Image.network(
                                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNXf8crJLB8uSKf9KBauyEfkOC6r4YZWamBRmF4Eu--O3NIOBKaraTEuYRL8fs59ZChKk&usqp=CAU',
                                            ),
                                          ),
                                        )),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          videoList.videos[index].memberName ??
                                              '닉네임 미등록 사용자',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          videoList.videos[index].createTime,
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
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    videoList.videos[index].content,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
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
                                        text: videoList
                                            .videos[index].questionContent,
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
                                  horizontal: 30,
                                  vertical: 10,
                                ),
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
                                          videoList.videos[index].likeCount
                                              .toString(),
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
                                          videoList.videos[index].commentCount
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
          ),
        ],
      ),
    );
  }
}
