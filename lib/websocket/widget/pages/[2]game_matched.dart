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
        ],
      ),
    );
  }

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
}

Widget getStage2(WebSocketClient client) {
  return Page2(client: client);
}
