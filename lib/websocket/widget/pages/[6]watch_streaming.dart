import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'streaming_page.dart';
import 'package:capston/websocket/message/message_type.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'dart:convert';

class Page6 extends StatefulWidget {
  final WebSocketClient client;

  Page6({this.client});

  @override
  _Page6State createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  Widget _buildImageFromEncodedData(String encodedImage,
      {double width, double height}) {
    if (encodedImage == null || encodedImage.isEmpty) {
      // 이미지가 없을 때 플레이스홀더 이미지 표시
      return Container(
        width: width,
        height: height,
        color: Colors.grey, // 또는 로딩 중을 나타내는 다른 UI 요소
      );
    }

    Uint8List imageBytes = base64.decode(encodedImage);
    ImageProvider imageProvider = MemoryImage(imageBytes);

    return Container(
      width: width,
      height: height,
      child: Image(
        image: imageProvider,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          // 로딩 진행 상태 표시
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() async {
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("[현재 발표자 세션 아이디] ${widget.client.state.currentBroadcaster}"); // <-- null 찍힘
    print(widget.client.state.memberInfos[0].sessionId);
    print(widget.client.state.memberInfos[1].sessionId);
    // print(widget.client.state.memberInfos[2].sessionId);
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6fa8dc), Color(0xFF8A61D4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Q. ${widget.client.state.gameInfo.question[widget.client.state.gameInfo.round - 1]}",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }
}

Widget getStage6(WebSocketClient client) {
  return Page6(client: client);
}
