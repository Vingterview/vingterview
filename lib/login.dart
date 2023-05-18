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
    String title;
    String selectedUrl;

    // final GoogleSignIn _googleSignIn = GoogleSignIn();
    // await _googleSignIn.signIn();

    final googleClientId =
        'http://ec2-43-201-224-125.ap-northeast-2.compute.amazonaws.com:8080/oauth2/authorization/google';
    ;
    final callbackUrlScheme = 'myapp';

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
      // print("우와아아아");

      // // Use this code to get an access token
      // final response = await http
      //     .post(Uri.parse('https://www.googleapis.com/oauth2/v4/token'), body: {
      //   'client_id': googleClientId,
      //   'redirect_uri': '$callbackUrlScheme:/',
      //   'grant_type': 'authorization_code',
      //   'code': code,
      // });

      // // Get the access token from the response
      // String accessToken = jsonDecode(response.body)['access_token'] as String;
      // // callbackUrlScheme은 앱에서 등록한 scheme 이름과 같아야 합니다.
      // final uri = Uri.parse(result);
      // final queryParams = uri.queryParameters;
      // String auth_url = "https://accounts.google.com/o/oauth2/token";

      // -------------------------------------------------------------------------

      // String authorizationUrl =
      //     '$authEndpoint?response_type=code&client_id=$clientId&redirect_uri=$redirectUrl&scope=$scope';
      // String result = await FlutterWebAuth.authenticate(
      //     url: authorizationUrl, callbackUrlScheme: redirectUrl);

      // Uri authUrl = Uri.parse('https://accounts.google.com/o/oauth2/token');
      // Map<String, String> params = {
      //   'grant_type': 'authorization_code',
      //   'code': 'YOUR_CODE',
      //   'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
      //   'client_id': clientId,
      //   'client_secret': clientSecret,
      // };
      // var response = await http.post(authUrl, body: params);

      // // 인증 토큰을 추출합니다.
      // Map<String, String> headers = json.decode(response.body)['headers'];
      // String accessToken = headers['Authorization'].split(' ')[1];

      // // Google API를 요청합니다.
      // Uri url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=dune');
      // response = await http.get(url, headers: <String, String>{
      //   'Authorization': 'Bearer $accessToken',
      // });

      // // 응답을 인쇄합니다.
      // print(json.decode(response.body));

      // accessToken = queryParams['access_token'];

      // ----------------------------
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
      // body: WebView(
      //   initialUrl:
      //       'http://ec2-43-201-224-125.ap-northeast-2.compute.amazonaws.com:8080/oauth2/authorization/google',
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
    );
  }
}
