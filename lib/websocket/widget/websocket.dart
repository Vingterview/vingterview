import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../message/message_type.dart';
import 'timer_widget.dart';
import '../wsclient/game_state.dart';
import '../wsclient/websocket_client.dart';
import '../wsclient/stage.dart';

import 'pages/[1]start.dart';
import 'pages/[2]game_matched.dart';
import 'pages/[3]round_start.dart';
import 'pages/[4]show_participant.dart';
import 'pages/[5]ready_streaming.dart';
import 'pages/[6]watch_streaming.dart';
import 'pages/[7]start_poll.dart';
import 'pages/[8]show_result.dart';
import 'pages/[9]game_finish.dart';

class MyWebSocketApp extends StatefulWidget {
  WebSocketClient client;

  MyWebSocketApp({Key key}) : super(key: key);

  @override
  _MyWebSocketAppState createState() => _MyWebSocketAppState();
}

class _MyWebSocketAppState extends State<MyWebSocketApp> {
  int stageIndex = 0;
  final List<Widget> _stages = [];
  WebSocketClient _client;

  void updateStageIndex(int _index) {
    setState(() {
      stageIndex = _index;
    });
  }

  @override
  void initState() {
    _client = widget.client ?? WebSocketClient.getInstance(); // <-  토큰으로 들어와야 함
    _stages.addAll([
      getStage1(_client),
      getStage2(_client),
      getStage3(_client),
      getStage4(_client),
      getStage5(_client),
      getStage6(_client),
      getStage7(_client),
      getStage8(_client),
      getStage9(_client),
    ]);
    super.initState();
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
            body: Consumer<GameState>(
              builder: (context, gameState, child) {
                switch (gameState.stage) {
                  case Stage.GAME_MATCHED:
                    return getStage2(_client);
                  case Stage.ROUND_START:
                    return getStage3(_client);
                  case Stage.SHOW_PARTICIPANT:
                    return getStage4(_client);
                  case Stage.READY_STREAMING:
                    return getStage5(_client);
                  case Stage.WATCH_STREAMING:
                    return getStage6(_client);
                  case Stage.START_POLL:
                    return getStage7(_client);
                  case Stage.SHOW_RESULT:
                    return getStage8(_client);
                  case Stage.GAME_FINISH:
                    return getStage9(_client);
                  default:
                    return getStage1(_client); // 기본값 -> 매칭 시작
                }
              },
            ));
      },
    );
  }
}
