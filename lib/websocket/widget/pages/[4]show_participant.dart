import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'dart:convert';

class Page4 extends StatefulWidget {
  final WebSocketClient client;

  Page4({this.client});

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.client.state.gameInfo.participant
                                  .contains(memberInfo.sessionId)
                              ? Colors.blue
                              : Colors.transparent,
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
            ],
          ),
        ],
      ),
    );
  }
}

Widget getStage4(WebSocketClient client) {
  return Page4(client: client);
}
