import 'package:flutter/material.dart';
import '../providers/videos_api.dart';
import '../providers/uploadmp4.dart';
import 'dart:io';
import 'package:capston/models/globals.dart';
import 'package:capston/models/questions.dart';
import 'pick_question.dart';
import 'record_video.dart';
import 'package:image_picker/image_picker.dart';
import 'video_write.dart';

class pick_df extends StatefulWidget {
  @override
  _pick_dfState createState() => _pick_dfState();
}

class _pick_dfState extends State<pick_df> {
  List<String> photos = [
    'assets/photo1.png',
    'assets/photo2.png',
    'assets/photo3.png',
    'assets/photo4.png',
    'assets/photo5.png',
    'assets/photo6.png',
  ];

  int selectedPhotoIndex;

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
            '사진 선택',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PostVideoPage(selectedIndex: selectedPhotoIndex),
                    ),
                  );
                })
          ]),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            '딥페이크를 적용할 사진을 선택하세요!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: photos.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPhotoIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedPhotoIndex == index
                            ? Color(0xFF8A61D4)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      photos[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class OtherPage extends StatelessWidget {
  final int selectedIndex;

  const OtherPage({Key key, this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('다른 페이지'),
      ),
      body: Center(
        child: Text('선택한 사진 인덱스: $selectedIndex'),
      ),
    );
  }
}
