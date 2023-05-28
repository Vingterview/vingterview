import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'package:capston/websocket/message/message_type.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'dart:convert';

class Page8 extends StatefulWidget {
  final WebSocketClient client;

  Page8({this.client});

  @override
  _Page8State createState() => _Page8State();
}

class _Page8State extends State<Page8> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  List<String> buttonValues = []; // 버튼 값 리스트
  String selectedValue; // 선택된 값

  Widget _buildImageFromEncodedData(String encodedImage,
      {double width, double height}) {
    Uint8List imageBytes = base64.decode(encodedImage);
    ImageProvider imageProvider = MemoryImage(imageBytes);
    return Container(
      width: width,
      height: height,
      child: Image(image: imageProvider, fit: BoxFit.cover),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
          seconds: Provider.of<GameState>(context, listen: false).duration),
    )..addListener(() {
        setState(() {});
      });

    _animationController.reverse(from: 1);

    buttonValues = widget.client.state.gameInfo.order;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - _animationController.value;

    String pollParticipantName = '';
    String pollParicipantImage = '';
    for (var memberInfo in widget.client.state.memberInfos) {
      if (memberInfo.sessionId == widget.client.state.poll) {
        pollParticipantName = memberInfo.name;
        pollParicipantImage = memberInfo.encodedImage;
        break;
      }
    }

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              for (var memberInfo in widget.client.state.memberInfos)
                Column(
                  children: [
                    Text(memberInfo.name),
                    _buildImageFromEncodedData(memberInfo.encodedImage,
                        width: 100, height: 100),
                  ],
                ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("가장 잘한 참가자 결과입니다!"),
                Column(
                  children: [
                    Text(pollParticipantName),
                    Image.network(pollParicipantImage),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.client.sendMessage(MessageType.NEXT);
                  },
                  child: Text('다음 라운드'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget getStage8(WebSocketClient client) {
  return Page8(client: client);
}
