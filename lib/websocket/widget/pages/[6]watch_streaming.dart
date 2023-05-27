import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';

class Page6 extends StatefulWidget {
  final WebSocketClient client;

  Page6({this.client});

  @override
  _Page6State createState() => _Page6State();
}

class _Page6State extends State<Page6> {
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
              Container(), // 받은 비디오
              TimerWidget(
                  secondsRemaining: Provider.of<GameState>(context).duration),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getStage6(WebSocketClient client) {
  return Page6(client: client);
}
