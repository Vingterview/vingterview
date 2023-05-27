import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../message/message_type.dart';
import 'timer_widget.dart';
import '../wsclient/game_state.dart';
import '../wsclient/websocket_client.dart';
import '../wsclient/stage.dart';

class oMyWebSocketApp extends StatefulWidget {
  final String title;

  WebSocketClient client;

  oMyWebSocketApp({Key key, @required this.title}) : super(key: key);

  @override
  _oMyWebSocketAppState createState() => _oMyWebSocketAppState();
}

class _oMyWebSocketAppState extends State<oMyWebSocketApp> {
  @override
  void initState() {
    widget.client = WebSocketClient.getInstance();
  }

  // 상태 클래스가 종료될 때 호출
  @override
  void dispose() {
    // 채널을 닫음
    widget.client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>(
      create: (context) => WebSocketClient.getInstance().state,
      builder: (context, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Provider.of<GameState>(context).stage.toString()),
                TimerWidget(
                    secondsRemaining: Provider.of<GameState>(context).duration),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.client.connectToSocket();
                        },
                        child: Text("Connect"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.client.disconnect();
                        },
                        child: Text("Disconnect"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.client.sendMessage(MessageType.PARTICIPATE);
                        },
                        child: Text('Participate'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // 버튼 간격 조절
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.client.sendMessage(MessageType.FINISH_VIDEO);
                        },
                        child: Text('Finish Streaming'),
                      ),
                    ),
                    SizedBox(width: 10), // 버튼 간격 조절
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.client.sendMessage(MessageType.POLL);
                        },
                        child: Text('Poll'),
                      ),
                    ),
                    SizedBox(width: 10), // 버튼 간격 조절
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.client.sendMessage(MessageType.NEXT);
                        },
                        child: Text('Next Round'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
