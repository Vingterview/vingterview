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
import 'function.dart';

class Page3 extends StatefulWidget {
  final WebSocketClient client;

  Page3({this.client});

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - _animationController.value;

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                )
            ],
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 12, 30, 62),
                            // Colors.black54,
                            Color.fromARGB(255, 63, 56, 76),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF8A61D4),
                          width: 2,
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: TimerPainter(
                        progress: progress,
                      ),
                      child: SizedBox(
                        width: 184,
                        height: 184,
                        child: Center(
                          child: Text(
                            widget.client.state.gameInfo.question[
                                widget.client.state.gameInfo.round - 1],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.client.sendMessage(MessageType.PARTICIPATE);
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15.0),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black38),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.blue.withOpacity(0.2)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: Color(0xFF8A61D4),
                              ),
                            ),
                          ),
                        ),
                        child: Text("참가하기",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  double progress;

  TimerPainter({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFF8A61D4)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    double radius = min(size.width, size.height) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);
    double startAngle = pi / 2; // Start angle at the bottom

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

Widget getStage3(WebSocketClient client) {
  return Page3(client: client);
}
