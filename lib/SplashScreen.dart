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
    print("로그인 상태 : " + isLogin.toString());
    if (isLogin) {
      return isLogin;
      String id = prefs.getString('id');
      String password = prefs.getString('password');
      print("저장 정보로 다시 시도");
      try {
        int member_id = await _userApi.userLogin(id, password);
        // login succeeded
        print('Login successful! Member ID: $member_id');
        await prefs.setBool('isLogin', true);
        return true;
      } catch (e) {
        // login failed
        print(e.toString());
        await prefs.setBool('isLogin', false);
        return false;
      }
    }
    return isLogin;
  }

  void moveScreen() async {
    bool isLogin = await checkLogin();
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
        child: CircularProgressIndicator(),
      ),
    );
  }
}
