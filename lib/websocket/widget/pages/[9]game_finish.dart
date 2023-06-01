import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'dart:convert';

class Page9 extends StatefulWidget {
  final WebSocketClient client;

  Page9({this.client});

  @override
  _Page9State createState() => _Page9State();
}

class _Page9State extends State<Page9> {
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
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text("게임 끝 ㅅㄱ",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            )),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
          onPressed: () {
            widget.client.disconnect();
            Navigator.pop(context);
          },
          child: Text("Disconnect"),
        ),
      ],
    ));
  }
}

Widget getStage9(WebSocketClient client) {
  return Page9(client: client);
}
