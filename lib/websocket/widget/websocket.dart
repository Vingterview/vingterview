import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../message/message_type.dart';
import 'timer_widget.dart';
import '../wsclient/game_state.dart';
import '../wsclient/websocket_client.dart';
import '../wsclient/stage.dart';
import 'package:capston/models/tags.dart';
import 'package:capston/pick_tags.dart';

import 'pages/[1]start.dart';
import 'pages/[2]game_matched.dart';
import 'pages/[3]round_start.dart';
import 'pages/[4]show_participant.dart';
import 'pages/[5]ready_streaming.dart';
import 'pages/[6]watch_streaming.dart';
import 'pages/[7]start_poll.dart';
import 'pages/[8]show_result.dart';
import 'pages/[9]game_finish.dart';
import 'pages/streaming_page.dart';

class MyWebSocketApp extends StatefulWidget {
  WebSocketClient client;

  MyWebSocketApp({Key key}) : super(key: key);

  @override
  _MyWebSocketAppState createState() => _MyWebSocketAppState();
}

class _MyWebSocketAppState extends State<MyWebSocketApp> {
  ///추가
  WebSocketClient _client;

  Stage _stage;
  List<Tags> selectedTags = [];

  @override
  void initState() {
    _client = widget.client ?? WebSocketClient.getInstance();
    super.initState();
  }

  // 상태 클래스가 종료될 때 호출
  @override
  void dispose() {
    // 채널을 닫음
    print("[dispose] websocket widget");
    if (widget.client != null) {
      widget.client.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>(
      create: (context) => WebSocketClient.getInstance().state,
      builder: (context, child) {
        ///추가
        _stage = Provider.of<GameState>(context).stage;

        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6fa8dc), Color(0xFF8A61D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: Text(
                '빙터뷰',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Consumer<GameState>(builder: (context, gameState, child) {
              Widget stageWidget;
              Widget memberWidget =
                  Container(); // <----------------------------------잘 되나 확인

              if (_isMatched()) {
                memberWidget = getStage2(_client);
              }

              switch (gameState.stage) {
                case Stage.GAME_MATCHED:
                  // stageWidget = getStage2(_client);
                  stageWidget = Container();
                  break;
                case Stage.ROUND_START:
                  stageWidget = getStage3(_client);
                  break;
                case Stage.SHOW_PARTICIPANT:
                  stageWidget = getStage4(_client);
                  stageWidget = Container();
                  break;
                case Stage.READY_STREAMING:
                  stageWidget = getStage5(_client);
                  break;
                case Stage.FINISH_STREAMING:
                case Stage.WATCH_STREAMING:
                  stageWidget = getStage6(_client);
                  break;
                case Stage.START_POLL:
                  stageWidget = getStage7(_client);
                  break;
                case Stage.SHOW_RESULT:
                  stageWidget = getStage8(_client);
                  break;
                case Stage.GAME_FINISH:
                  stageWidget = getStage9(_client);
                  break;
                default:
                  if (selectedTags.length != 0) {
                    print("?");
                    stageWidget = getStage1(_client, selectedTags);
                  } else {
                    stageWidget = Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 230),
                          ElevatedButton(
                            onPressed: () async {
                              selectedTags = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => pick_tags(
                                          selectedTags: selectedTags)));
                              if (selectedTags != null) {
                                // Tags 객체를 전달받으면 처리
                                print(selectedTags);
                                setState(() {}); // 변경 적용
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.blue.withOpacity(0.2)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: Color(0xFF8A61D4),
                                  ),
                                ),
                              ),
                              elevation: MaterialStateProperty.all<double>(5.0),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(25.0)),
                            ),
                            child: Text(
                              '태그 선택',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '받고 싶은 질문의 태그를 선택하세요!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              }
              return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 12, 30, 62),
                        // Colors.black54,
                        Color.fromARGB(255, 170, 155, 198),
                      ],
                    ),
                  ), // 검정색 배경 설정
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        memberWidget,
                        stageWidget,

                        ///추가 : StreamingPage 사용법
                        Expanded(
                            child: Container(
                                // 화면 크기에 맞게 적절한 높이 설정
                                height: MediaQuery.of(context).size.height,
                                child: Visibility(
                                    visible: _isStreaming(),
                                    child: StreamingPage(
                                      token: Provider.of<GameState>(context)
                                          .agoraToken,
                                      channelName:
                                          Provider.of<GameState>(context)
                                              .roomId,
                                      isHost: _isHost(),
                                      currentBroadcaster:
                                          Provider.of<GameState>(context)
                                              .currentBroadcaster,
                                      onStart: () {
                                        _client.sendMessage(
                                            MessageType.START_VIDEO);
                                      },
                                      onFinished: () {
                                        _client.sendMessage(
                                            MessageType.FINISH_VIDEO);
                                      },
                                    ))))
                      ],
                    ),
                  ));
            }));
      },
    );
  }

  ///추가
  bool _isStreaming() {
    print("[isStreaming] $_stage");
    if (_stage == Stage.WATCH_STREAMING || _stage == Stage.READY_STREAMING) {
      return true;
    } else {
      return false;
    }
  }

  ///추가
  bool _isHost() {
    if (_stage == Stage.READY_STREAMING) {
      return true;
    }
    return false;
  }

  bool _isMatched() {
    if (_stage != null) {
      print(_stage);
      return true;
    }
    return false;
  }
}
