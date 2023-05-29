import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'dart:convert';

class Page2 extends StatefulWidget {
  final WebSocketClient client;

  Page2({this.client});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  Widget _buildImageFromEncodedData(String encodedImage,
      {double width, double height, double borderWidth, Color borderColor}) {
    Uint8List imageBytes = base64.decode(encodedImage);
    ImageProvider imageProvider = MemoryImage(imageBytes);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // 이미지를 동그랗게 만듦
        border: Border.all(
            color: borderColor ??
                Colors.black, // border 색상을 입력받아 설정하며, 기본값은 검정색입니다.
            width: borderWidth ??
                8 // border 너비를 입력받아 설정하며, 기본값은 0입니다. (border가 없음)
            ),
      ),
      child: ClipOval(
        child: Image(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              for (var memberInfo in widget.client.state.memberInfos)
                Container(
                  margin: EdgeInsets.all(8.0), // 여백 추가
                  child: Column(
                    children: [
                      _buildImageFromEncodedData(memberInfo.encodedImage,
                          width: 90,
                          height: 90,
                          borderWidth: 4,
                          borderColor: Colors.black45),
                      SizedBox(height: 8), // 사진과 글자 사이 여백
                      Text(
                        memberInfo.name,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getStage2(WebSocketClient client) {
  return Page2(client: client);
}
