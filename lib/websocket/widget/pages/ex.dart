import 'package:flutter/material.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'package:capston/websocket/message/message_type.dart';
import 'package:provider/provider.dart';
import '../timer_widget.dart';

class websoPage extends StatefulWidget {
  WebSocketClient client;

  websoPage({Key key}) : super(key: key);

  @override
  _websoPage createState() => _websoPage();
}

class _websoPage extends State<websoPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
