import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../message/message_type.dart';
import 'timer_widget.dart';
import '../wsclient/game_state.dart';
import '../wsclient/websocket_client.dart';

class MyWebSocketApp extends StatefulWidget {
  WebSocketClient client;

  MyWebSocketApp({Key key}) : super(key: key);

  @override
  _MyWebSocketAppState createState() => _MyWebSocketAppState();
}

class _MyWebSocketAppState extends State<MyWebSocketApp> {
  @override
  void initState() {
    widget.client = WebSocketClient.getInstance(); // <-  토큰으로 들어와야 함
  }

  // 상태 클래스가 종료될 때 호출
  @override
  void dispose() {
    // 채널을 닫음
    if (widget.client == null) {
      return;
    }
    widget.client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>(
      create: (context) => WebSocketClient.getInstance().state,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text("소켓")),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Provider.of<GameState>(context)
                    .stage
                    .toString()), // 이거에 따라서 switch문으로 위젯 불러내면 될 듯?
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
