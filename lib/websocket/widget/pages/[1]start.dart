import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'package:capston/websocket/wsclient/stage.dart';
import 'package:capston/models/tags.dart';

class Page1 extends StatefulWidget {
  final WebSocketClient client;
  final List<Tags> selectedtags;

  Page1({this.client, this.selectedtags});

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool isMatching = false;
  @override
  Widget build(BuildContext context) {
    List<int> selectedTagId = [];
    for (var tag in widget.selectedtags) {
      selectedTagId.add(tag.tagId);
    }
    print(selectedTagId);

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 250),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var tag in widget.selectedtags)
                Container(
                  margin: EdgeInsets.fromLTRB(0, 4, 4, 0),
                  child: ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          Color.fromARGB(233, 214, 204, 232),
                          Color.fromARGB(223, 165, 175, 222),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      '#${tag.tagName}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          ElevatedButton(
            onPressed: () async {
              // await widget.client.connectToSocket();
              await widget.client.connectToSocket(selectedTagId);
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
          SizedBox(height: 20),
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

Widget getStage1(WebSocketClient client, List<Tags> selectedtags) {
  return Page1(client: client, selectedtags: selectedtags);
}
