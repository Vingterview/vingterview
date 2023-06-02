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
  List<String> buttonValues = []; // 버튼 값 리스트
  String selectedValue; // 선택된 값
  bool isPushed = false;
  String pollParticipantName;
  String pollParicipantImage;

  Widget _buildImageFromEncodedData(String encodedImage,
      {double width, double height}) {
    if (encodedImage == null || encodedImage.isEmpty) {
      // 이미지가 없을 때 플레이스홀더 이미지 표시
      return Container(
        width: width,
        height: height,
        color: Colors.grey, // 또는 로딩 중을 나타내는 다른 UI 요소
      );
    }

    Uint8List imageBytes = base64.decode(encodedImage);
    ImageProvider imageProvider = MemoryImage(imageBytes);

    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF8A61D4),
            width: 4,
          ),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              // 로딩 진행 상태 표시
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),
        ));
  }

  @override
  void initState() {
    super.initState();

    buttonValues = widget.client.state.gameInfo.order;
    whopoll();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> whopoll() {
    for (var memberInfo in widget.client.state.memberInfos) {
      // print("${memberInfo.name}");
      print("${memberInfo.sessionId}아이디");
      print("${widget.client.state.poll}poll");
      if (memberInfo != null &&
          memberInfo.sessionId == widget.client.state.poll) {
        // print("${memberInfo.name}");
        setState(() {
          pollParticipantName = memberInfo.name;
          pollParicipantImage = memberInfo.encodedImage;
        });
      }
    }
    print(pollParticipantName);
  }

  @override
  Widget build(BuildContext context) {
    whopoll();
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("가장 잘한 참가자 결과입니다!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                Column(
                  children: [
                    Text("$pollParticipantName님, 축하합니다!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    _buildImageFromEncodedData(
                      pollParicipantImage,
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: isPushed
                      ? null
                      : () {
                          widget.client.sendMessage(MessageType.NEXT);
                          setState(() {
                            isPushed = true;
                          });
                        },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(15.0),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isPushed ? Colors.grey : Colors.black38,
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    overlayColor: MaterialStateProperty.all<Color>(
                        Colors.blue.withOpacity(0.2)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Color(0xFF8A61D4),
                        ),
                      ),
                    ),
                  ),
                  child: Text('다음 라운드',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

Widget getStage8(WebSocketClient client) {
  return Page8(client: client);
}
