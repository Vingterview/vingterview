import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'dart:convert';

class Page2 extends StatefulWidget {
  final WebSocketClient client;

  Page2({this.client});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  Widget _buildImageFromEncodedData(String encodedImage,
      {double width, double height, double borderWidth, Color borderColor}) {
    Uint8List imageBytes = base64.decode(encodedImage);
    ImageProvider imageProvider = MemoryImage(imageBytes);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              for (var memberInfo in widget.client.state.memberInfos)
                Container(
                  margin: EdgeInsets.all(8.0), // 여백 추가
                  child: Column(
                    children: [
                      Text(
                        memberInfo.name,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 8), // 사진과 글자 사이 여백
                      _buildImageFromEncodedData(
                        memberInfo.encodedImage,
                        width: 50,
                        height: 50,
                        borderWidth: 4,
                        borderColor: widget.client.state.currentBroadcaster ==
                                memberInfo.sessionId
                            ? Colors.red
                            : (widget.client.state.gameInfo.participant !=
                                        null &&
                                    widget.client.state.gameInfo.participant
                                        .contains(memberInfo.sessionId)
                                ? Colors.blue
                                : Colors.black54),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getStage2(WebSocketClient client) {
  return Page2(client: client);
}
