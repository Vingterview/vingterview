import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

String BASE_URL =
    "http://ec2-43-201-224-125.ap-northeast-2.compute.amazonaws.com:8080";

class HomePage extends StatelessWidget {
  String accessToken;
  String refreshToken;

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Map<String, dynamic> parseJwtPayLoad(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  void _handleGoogleLogin(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen()),
    );

    ///url에서 토큰 추출
    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', false);
      Uri uri = Uri.parse(result);
      accessToken = uri.queryParameters['access_token'];
      refreshToken = uri.queryParameters['refresh_token'];
      prefs.setString('access_token', accessToken);
      print(accessToken);
      Map<String, dynamic> tokenContent = parseJwtPayLoad(accessToken);
      prefs.setInt('member_id', int.parse(tokenContent['memberId']));
      print("${tokenContent['memberId']} id");
      await prefs.setBool('isLogin', true);
      Navigator.pushReplacementNamed(context, '/index');
    }
  }

  ///테스트
  void _getBoards() async {
    final response = await http.get(Uri.parse("$BASE_URL/boards"),
        headers: {'Authorization': 'Bearer $accessToken'});
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200),
            Image(
              image: AssetImage(
                'assets/_logo.png',

                // adjust the width and alignment as needed
              ),
              height: 150,
            ),
            SizedBox(height: 200),
            Text(
              'SNS 로그인',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () => _handleGoogleLogin(context),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: Text(
                        'Google 계정으로 가입',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final urlToNavigate = '$BASE_URL/token'; // 웹뷰에 진입할 URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: WebView(
        // initialUrl: '$BASE_URL/oauth2/authorization/google',
        initialUrl: '$BASE_URL/login',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          print(request.url);
          if (request.url.startsWith(urlToNavigate)) {
            print(request.url);
            Navigator.pop(context, request.url);

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        userAgent: "ving",
      ),
    );
  }
}
