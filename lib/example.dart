import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

String BASE_URL =
    "http://ec2-43-201-224-125.ap-northeast-2.compute.amazonaws.com:8080";

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  String accessToken;
  String refreshToken;

  void _handleGoogleLogin(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen()),
    );

    ///url에서 토큰 추출
    if (result != null) {
      Uri uri = Uri.parse(result);
      accessToken = uri.queryParameters['access_token'];
      refreshToken = uri.queryParameters['refresh_token'];
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
      appBar: AppBar(
        title: Text('홈'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleGoogleLogin(context),
          child: Text('Google 로그인'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: _getBoards,
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
      appBar: AppBar(
        title: Text('Webview Example'),
      ),
      body: WebView(
        // initialUrl: '$BASE_URL/oauth2/authorization/google',
        initialUrl: '$BASE_URL/login',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          print(request.url);
          if (request.url.startsWith(urlToNavigate)) {
            print(request.url);
            // 특정 URL에 도달하면 웹뷰를 종료하고 다른 위젯으로 전환
            Navigator.pop(context, request.url);

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => OtherWidget()),
            // );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        userAgent: "ving",
      ),
    );
  }
}

// class OtherWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Other Widget'),
//       ),
//       body: Center(
//         child: Text('This is another widget.'),
//       ),
//     );
//   }
// }