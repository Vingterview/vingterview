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

class Page7 extends StatefulWidget {
  final WebSocketClient client;

  Page7({this.client});

  @override
  _Page7State createState() => _Page7State();
}

class _Page7State extends State<Page7> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  List<String> buttonValues = []; // 버튼 값 리스트
  String selectedValue; // 선택된 값
  bool isPolled = false;

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

    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("가장 잘한 참가자를 선택해주세요!"),
                Row(
                  children: [
                    for (int index = 0; index < buttonValues.length; index++)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedValue = buttonValues[index];
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: (selectedValue ==
                                  buttonValues[index])
                              ? MaterialStateProperty.all<Color>(Colors.blue)
                              : null,
                        ),
                        child: Text((index + 1).toString()),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (selectedValue != null)
                      ? () {
                          widget.client.state.poll = selectedValue;
                          widget.client.sendMessage(MessageType.POLL);
                        }
                      : null,
                  child: Text('투표하기'),
                ),
                SizedBox(height: 20),
                CustomPaint(
                  painter: TimerPainter(
                    progress: progress,
                  ),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Text(
                        "${(_animationController.value * Provider.of<GameState>(context).duration).ceil()}",
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
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

Widget getStage7(WebSocketClient client) {
  return Page7(client: client);
}
