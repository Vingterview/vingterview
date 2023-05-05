import 'package:flutter/material.dart';
import '../providers/users_api.dart';
import 'package:capston/models/globals.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:question_player/question_player.dart';
class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  String _accessToken = '';

  Future<void> _loginWithGoogle() async {
    // App specific variables
    final googleClientId =
        'http://ec2-43-201-224-125.ap-northeast-2.compute.amazonaws.com:8080/oauth2/authorization/google';
    ;
    final callbackUrlScheme =
        'com.googleusercontent.apps.XXXXXXXXXXXX-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

    final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'response_type': 'code',
      'client_id': googleClientId,
      'redirect_uri': '$callbackUrlScheme:/',
      'scope': 'email',
    });

    try {
      // final result = await FlutterWebAuth.authenticate(
      //     url:
      //         'http://ec2-43-201-224-125.ap-northeast-2.compute.amazonaws.com:8080/oauth2/authorization/google',
      //     callbackUrlScheme: callbackUrlScheme);
      // final code = Uri.parse(result).queryParameters['code'];

      // // Use this code to get an access token
      // final response = await http
      //     .post(Uri.parse('https://www.googleapis.com/oauth2/v4/token'), body: {
      //   'client_id': googleClientId,
      //   'redirect_uri': '$callbackUrlScheme:/',
      //   'grant_type': 'authorization_code',
      //   'code': code,
      // });

      // // Get the access token from the response
      // final accessToken = jsonDecode(response.body)['access_token'] as String;
      // // callbackUrlScheme은 앱에서 등록한 scheme 이름과 같아야 합니다.
      // // final uri = Uri.parse(result);
      // // final queryParams = uri.queryParameters;
      // // final accessToken = queryParams['access_token'];
      // print(accessToken);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', true);
      prefs.setString('access_token',
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJuYXJ1Y29tMDFAZ21haWwuY29tIiwibWVtYmVySWQiOiI1IiwiaWF0IjoxNjgzMjc0MTQwLCJleHAiOjE2OTEwNTAxNDB9.y0DkhfZoo4AHWXJ6RlOHi7drtYyIvJo9c03sm-UGK6o");
      Navigator.pushReplacementNamed(context, '/index');
      setState(() {
        // print(accessToken);
      });
    } catch (e) {
      // 에러 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: false
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    _loginWithGoogle();
                    setState(() {
                      // _isSigningIn = true;
                    });

                    // TODO: Add method call to the Google Sign-In authentication

                    setState(() {
                      // _isSigningIn = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/google_logo.png"),
                          height: 35.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
