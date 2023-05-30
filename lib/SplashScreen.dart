import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/users_api.dart';
import 'package:capston/models/globals.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserApi _userApi = UserApi();
  String uri = myUri;

  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    if (isLogin) {
      if (prefs.getString('access_token') != null)
        return false;
      else
        return false;
    }
    return false;
  }

  void moveScreen() async {
    bool isLogin = await checkLogin();
    print(isLogin);
    if (isLogin) {
      Navigator.pushReplacementNamed(context, '/index');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      moveScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(
            'assets/_logo.png',

            // adjust the width and alignment as needed
          ),
          height: 150,
        ),
      ),
    );
  }
}
