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
    Uint8List imageBytes = base64.decode(encodedImage);
    ImageProvider imageProvider = MemoryImage(imageBytes);
    return Container(
      width: width,
      height: height,
      child: Image(image: imageProvider, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            for (var memberInfo in widget.client.state.memberInfos)
              Column(
                children: [
                  Text(memberInfo.name),
                  _buildImageFromEncodedData(memberInfo.encodedImage,
                      width: 100, height: 100),
                ],
              ),
          ],
        ),
        Text("게임 끝 ㅅㄱ"),
        ElevatedButton(
          onPressed: () {
            widget.client.disconnect();
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
