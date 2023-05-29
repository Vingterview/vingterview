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
    print("ttttttttttttttttttttttttttttttttttttttttttttttttt");
    print(widget.client.state.currentBroadcaster);
    print(widget.client.state.memberInfos[0].sessionId);
    print(widget.client.state.memberInfos[1].sessionId);
    print(widget.client.state.memberInfos[2].sessionId);
    return Container(
      child: Column(children: [
        Row(children: [
          for (var memberInfo in widget.client.state.memberInfos)
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.client.state.currentBroadcaster ==
                              memberInfo.sessionId
                          ? Colors.red
                          : (widget.client.state.gameInfo.participant
                                  .contains(memberInfo.sessionId)
                              ? Colors.blue
                              : Colors.transparent),
                      width: 2,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: [
                      Text(memberInfo.name),
                      _buildImageFromEncodedData(memberInfo.encodedImage,
                          width: 100, height: 100),
                    ],
                  ),
                ),
              ],
            ),
        ]),
        Text(widget.client.state.gameInfo
            .question[widget.client.state.gameInfo.round - 1]),
      ]),
    );
  }
}

Widget getStage6(WebSocketClient client) {
  return Page6(client: client);
}
