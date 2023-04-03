import 'package:flutter/material.dart';

import '../models/users.dart';
import '../providers/users_api.dart';

class MyPage extends StatelessWidget {
  UserApi userApi = UserApi();
  Users user;
  bool isLoading = true;

  Future initUser() async {
    user = await userApi.getUser(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: userApi.getUser(1),
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
            child: Text(
              user.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        }
      },
    );
  }
}



Widget getMyPage() {
  return MyPage();
}