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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(Provider.of<GameState>(context).stage.toString()),
          TimerWidget(
              secondsRemaining: Provider.of<GameState>(context).duration),
          SizedBox(height: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await widget.client.connectToSocket();
              },
              child: Text("매칭 시작"),
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
