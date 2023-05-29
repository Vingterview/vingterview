import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'package:capston/websocket/wsclient/stage.dart';

class Page1 extends StatefulWidget {
  final WebSocketClient client;

  Page1({this.client});

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool isMatching = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 280),
          ElevatedButton(
            onPressed: () async {
              await widget.client.connectToSocket();
              setState(() {
                isMatching = true;
              });
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(
                  Colors.blue.withOpacity(0.2)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Color(0xFF8A61D4),
                  ),
                ),
              ),
              elevation: MaterialStateProperty.all<double>(5.0),
              padding:
                  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(25.0)),
            ),
            child: Text(
              (isMatching) ? '매칭 중...' : '매칭 시작',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            (isMatching) ? '매칭을 기다리는 중입니다!' : '지금 바로 시작 버튼을 누르세요!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

Widget getStage1(WebSocketClient client) {
  return Page1(client: client);
}
