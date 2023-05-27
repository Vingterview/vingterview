import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'package:capston/websocket/message/message_type.dart';

class Page5 extends StatefulWidget {
  final WebSocketClient client;

  Page5({this.client});

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
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
                          Image.network(memberInfo.encodedImage),
                        ],
                      ),
                    ),
                  ],
                ),
              Text(widget.client.state.gameInfo
                  .question[widget.client.state.gameInfo.round - 1]),
              Container(), // 내 카메라
              ElevatedButton(
                onPressed: () {
                  widget.client.sendMessage(MessageType.FINISH_VIDEO);
                },
                child: Text('Finish Streaming'),
              ),
              TimerWidget(
                  secondsRemaining: Provider.of<GameState>(context).duration),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getStage5(WebSocketClient client) {
  return Page5(client: client);
}
