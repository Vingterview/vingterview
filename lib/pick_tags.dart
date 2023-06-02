import 'package:flutter/material.dart';
import '../models/tags.dart';
import '../providers/tags_api.dart';

class pick_tags extends StatefulWidget {
  final List<Tags> selectedTags;
  pick_tags({@required this.selectedTags});
  @override
  _pick_tagsState createState() => _pick_tagsState(selectedTags: selectedTags);
}

class _pick_tagsState extends State<pick_tags> {
  TagApi tagApi = TagApi();
  List<Tags> tagList = [];
  List<Tags> selectedTags = [];
  _pick_tagsState({@required this.selectedTags});
  Tags parentTag;

  @override
  void initState() {
    super.initState();
    initTag();
    print("init");
  }

  Future<void> initTag() async {
    selectedTags = widget.selectedTags;
    List<Tags> _tagList;
    if (selectedTags.isEmpty) {
      _tagList = await tagApi.getTags();
    } else {
      parentTag = selectedTags[selectedTags.length - 1];
      _tagList =
          await tagApi.getTags(query: 1, param: parentTag.tagId.toString());
    }
    print(tagList);
    setState(() {
      tagList = _tagList;
    }); // 상태 변경 알림
  }

  Future<void> selectTag(Tags tag) async {
    selectedTags.add(tag);
    if (selectedTags.length < 3) {
      selectedTags = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => pick_tags(selectedTags: selectedTags)));
    }
    Navigator.pop(context, selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6fa8dc), Color(0xFF8A61D4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          '태그 선택',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: tagList.length,
          itemBuilder: (BuildContext context, int index) {
            Tags tag = tagList[index];
            return InkWell(
              onTap: () {
                selectTag(tag);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                margin: EdgeInsets.symmetric(
                  vertical: 3,
                ),
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
                  "#${tagList[index].tagName}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedTags);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
