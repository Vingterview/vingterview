// ignore_for_file: prefer_conditional_assignment

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../message/message_type.dart';

import '../message/message.dart';
import 'game_state.dart';
import 'stage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capston/models/globals.dart';

class WebSocketClient {
  StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();
  Stream<dynamic> get messageStream => _messageController.stream;

  ///singleton instance
  static WebSocketClient _instance;
  String token;

  Future<String> get_token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString('access_token'));
  }

  static String BASE_URL = myUri.substring(7);

  ///WebSocket member fields
  IOWebSocketChannel _channel;
  bool _isConnected = false;
  final _sendBuffer = Queue();

  ///WebSocket connections member fields
  final _reconnectIntervalMs = 5000;
  Timer _reconnectTimer;
  int _reconnectCount = 5;
  // Timer heartBeatTimer;
  // final _heartbeatInterval = 10;

  ///Game state
  GameState state = new GameState();

  ///timer state
  int _participateSec = 60; //질문 확인하고 참가하는 시간 60초
  int _pollSec = 30; //투표하는 시간 30초
  bool _isAlive = false;

  ///private constructor
  WebSocketClient._();

  /// singleton 객체 획득 메소드
  static WebSocketClient getInstance() {
    if (_instance == null) {
      _instance = WebSocketClient._();
    }
    return _instance;
  }

  IOWebSocketChannel get channel => _channel;

  /**
   * public methods
   */

  ///웹소켓 연결
  connectToSocket() async {
    if (!_isConnected) {
      String endPoint = "ws://$BASE_URL/ving";
      token = await get_token();
      print(token);
      print(endPoint);
      print(_isConnected);
      WebSocket.connect(endPoint, headers: {'Authorization': 'Bearer $token'})
          .then((ws) {
        _channel = IOWebSocketChannel(ws);
        if (_channel != null) {
          print("Websocket connected");
          _reconnectCount = 120;
          _reconnectTimer?.cancel();
          _listenToMessage();
          _isConnected = true;
          // _startHeartBeatTimer();

          //버퍼에 남아있는 메세지를 모두 전송
          while (_sendBuffer.isNotEmpty) {
            String text = _sendBuffer.first;
            _sendBuffer.remove(text);
            _push(text);
          }
        }
      }).onError((error, stackTrace) {
        //에러 발생시 현재 연결을 끊고 다시 연결 시도
        print("failed to connect channel");
        disconnect();
        _reconnect();
      });
    }
  }

  ///웹소켓 연결 해제
  disconnect() {
    print("disconnect channel");
    _channel?.sink?.close(status.goingAway);
    _reconnectTimer?.cancel();
    _isConnected = false;
    // heartBeatTimer?.cancel();
  }

  ///json으로 변환 후 메세지 전송
  sendMessage(MessageType type) {
    if (type == MessageType.PARTICIPATE || type == MessageType.POLL) {
      if (!_isAlive) {
        return;
      }
    }

    Message message = Message(
        type: type,
        roomId: state.roomId,
        sessionId: state.sessionId,
        gameInfo: state.gameInfo,
        memberInfos: [], // 참여하는 멤버들 정보 (member.dart)
        poll: state.poll);

    _push(jsonEncode(message));
  }

  sendBinary(Uint8List binary) {
    if (_channel.sink != null && binary != null) {
      // 스트림 싱크가 열려 있는지 확인
      _channel.sink.add(binary); // 데이터 보내기
    } else {
      print('스트림 싱크가 닫혀 있습니다.');
    }
  }

  /**
   * private methods
   */

  ///재연결
  _reconnect() async {
    if ((_reconnectTimer == null ||
            !_reconnectTimer.isActive) // 재연결을 시도하는 중이 아니고
        &&
        _reconnectCount > 0) {
      // 재연결 횟수가 남아있으면
      print("try to reconnect");
      _reconnectTimer = Timer.periodic(Duration(seconds: _reconnectIntervalMs),
          (Timer timer) async {
        if (_reconnectCount == 0) {
          _reconnectTimer?.cancel();
          return;
        }
        await connectToSocket(); //연결 시도
        _reconnectCount--;
      });
    }
  }

  ///메세지 수신
  _listenToMessage() {
    _channel.stream.listen((msg) {
      if (msg is String) {
        Message message = Message.fromJson(jsonDecode(msg));
        switch (message.type) {
          case MessageType.CREATE:
            //set : 방 정보, 세션 정보
            state.sessionId = message.sessionId;
            state.roomId = message.roomId;
            state.memberInfos = message.memberInfos;

            //signal : game matched
            state.notifyState(Stage.GAME_MATCHED);

            break;

          case MessageType.START:
            //set : 질문3개, 현재 라운드, 참가신청 받는 시간
            state.gameInfo.question = message.gameInfo.question;
            state.gameInfo.round = message.gameInfo.round;
            state.duration = _participateSec;

            //timer start
            _setTimer(Duration(seconds: _participateSec),
                MessageType.FINISH_PARTICIPATE);

            //signal : show question & ask participate
            state.notifyState(Stage.ROUND_START);
            break;

          case MessageType.INFO:
            //set : 답변 순서, 참가자 정보
            state.gameInfo.order = message.gameInfo.order;
            state.gameInfo.participant = message.gameInfo.participant;

            //signal : show participant
            state.notifyState(Stage.SHOW_PARTICIPANT);
            break;

          case MessageType.TURN:
            //signal : ready & start streaming
            state.notifyState(Stage.READY_STREAMING);
            break;

          case MessageType.VIDEO:
            //signal : show video stream
            state.notifyState(Stage.WATCH_STREAMING);
            break;

          case MessageType.POLL:
            //set : 투표 시간
            state.duration = _pollSec;

            //timer start
            _setTimer(Duration(seconds: _pollSec), MessageType.FINISH_POLL);

            //signal : start poll
            state.notifyState(Stage.START_POLL);
            break;

          case MessageType.RESULT:
            //set : 투표 결과
            state.poll = message.poll;

            //signal : show result
            state.notifyState(Stage.SHOW_RESULT);
            break;

          case MessageType.FINISH_GAME:
            //웹소켓 연결 해제
            disconnect();

            //signal : game finish
            state.notifyState(Stage.GAME_FINISH);
            break;

          default:
            break;
        }
      } else if (msg is Uint8List) {
        print("received : ${msg.length}");
        _messageController.add(msg);
      }
    }, onDone: () {
      print("fail to receive message");
      disconnect();
      _reconnect();
    }, onError: (error) {
      print(error);
    });
  }

  ///메세지 전송
  _push(String text) {
    if (_isConnected) {
      print("message sent");
      _channel.sink.add(text);
    } else {
      print("message added to buffer");
      _sendBuffer.add(text);
    }
  }

  ///연결 상태 점검
  // _startHeartBeatTimer() {
  //   heartBeatTimer =
  //       Timer.periodic(Duration(seconds: _heartbeatInterval), (Timer timer) {
  //         _channel.sink?.add(_heartbeatData);
  //       });
  // }

  /**
   * utility method
   */

  ///타이머 설정
  _setTimer(Duration duration, MessageType type) {
    _isAlive = true;
    Future.delayed(duration, () {
      sendMessage(type);
      _isAlive = false;
    });
  }
}
