import 'package:flutter/material.dart';
import '../models/tags.dart';
import '../providers/tags_api.dart';

class pick_tags extends StatefulWidget {
  @override
  _pick_tagsState createState() => _pick_tagsState();
}

class _pick_tagsState extends State<pick_tags> {
  TagApi tagApi = TagApi();
  List<Tags> tagList;
  List<Tags> selectedTags = []; // 리스트 초기화

  @override
  void initState() {
    super.initState();
    initTag();
    print("init");
  }

  Future<void> initTag() async {
    tagList = await tagApi.getTags();
    print(tagList);
  }

  void selectTag(Tags tag) {
    if (selectedTags.length < 3) {
      // 선택된 태그가 3개 이하인 경우만 추가
      setState(() {
        selectedTags.add(tag); // 선택한 태그를 리스트에 추가
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('태그 조회용'),
      ),
      body: ListView.builder(
        itemCount: tagList.length,
        itemBuilder: (BuildContext context, int index) {
          Tags tag = tagList[index];
          return InkWell(
            onTap: () {
              selectTag(tag); // 태그를 선택하면 선택한 태그를 저장하는 함수 호출
            },
            child: Container(
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
                tagList[index].tagName,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedTags); // 선택된 태그 리스트를 반환
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
