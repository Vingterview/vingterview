import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';

class Page9 extends StatefulWidget {
  final WebSocketClient client;

  Page9({this.client});

  @override
  _Page9State createState() => _Page9State();
}

class _Page9State extends State<Page9> {
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
                  Image.network(memberInfo.encodedImage),
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
