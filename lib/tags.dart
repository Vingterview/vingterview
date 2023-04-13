import 'package:flutter/material.dart';
import '../models/tags.dart';
import '../providers/tags_api.dart';

class tag_detail extends StatelessWidget {
  TagApi tagApi = TagApi();
  List<Tags> tagList;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Future<void> inittag() async {
      tagList = await tagApi.getTags();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('태그 조회용'),
      ),
      body: FutureBuilder<void>(
        future: inittag(), // Call your inittag() function
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While fetching data, show a loading indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // If an error occurred while fetching data, show an error message
            return Center(
              child: Text('Error loading tags'),
            );
          } else {
            // Once data is fetched, display the tag and one tag
            return ListView.builder(
              itemCount: tagList.length, // Add 1 for the tag details Container
              itemBuilder: (BuildContext context, int index) {
                Tags tag =
                    tagList[index]; // Subtract 1 to account for tag details
                return Container(
                  padding: EdgeInsets.fromLTRB(
                      10, 5, 10, 10), // Set appropriate margins
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align left
                    children: [
                      Text(
                        tag.tagName ?? '태그 정보가 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
