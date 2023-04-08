import 'package:flutter/material.dart';
import 'dart:io';
import '../models/users.dart';
import '../providers/users_api.dart';
import '../providers/uploadImg.dart';
import '../providers/uploadmp4.dart';
import 'package:image_picker/image_picker.dart';

class MyPage extends StatelessWidget {
  UserApi userApi = UserApi();
  Users user;
  bool isLoading = true;
  UploadImageApi uploadImageApi = UploadImageApi();
  UploadVideoApi uploadVideoApi = UploadVideoApi();
  File _image;
  File _video;
  String uri = 'https://ee-wfnlp.run.goorm.site';

  Future initUser() async {
    user = await userApi.getUserDetail(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: userApi.getUserDetail(1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner if the data is not yet available
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if there was an error loading the data
          return Center(child: Text('Error loading user data'));
        } else {
          // Build the widget tree with the loaded data
          Users user = snapshot.data;
          return Container(
              child: ListView(children: [
            Text(
              user.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: uploadImageApi.pickImage,
            ),
            if (_image != null) Image.file(_image),
            ElevatedButton(
              child: Text('Upload'),
              onPressed: uploadImageApi.pickImage,
            ),
            // Image.network('$uri${user.profile_image_url}'),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: uploadVideoApi.pickVideo,
            ),
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await userApi.logoutUser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('로그아웃합니다.')),
                  );
                  Navigator.of(context).pushReplacementNamed('/login');
                }),
          ]));
        }
      },
    );
  }
}

Widget getMyPage() {
  return MyPage();
}
