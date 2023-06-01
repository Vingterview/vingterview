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
                Text(
                  "가장 잘한 참가자를 선택해주세요!",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int index = 0; index < buttonValues.length; index++)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedValue = buttonValues[index];
                          });
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15.0),
                          ),
                          backgroundColor:
                              (selectedValue == buttonValues[index])
                                  ? MaterialStateProperty.all<Color>(
                                      Color(0xFF6fa8dc),
                                    )
                                  : null,
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          overlayColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
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
                        child: Text((index + 1).toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            )),
                      ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (selectedValue != null && !isPolled)
                      ? () {
                          widget.client.state.poll = selectedValue;
                          widget.client.sendMessage(MessageType.POLL);
                        }
                      : null,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(15.0),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isPolled ? Colors.grey : Colors.black38,
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
                  child: Text('투표하기',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                ),
                SizedBox(height: 10),
                Stack(alignment: Alignment.center, children: [
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
                        width: 3,
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
                          "${(_animationController.value * Provider.of<GameState>(context).duration).ceil()}",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
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
      ..color = Color.fromARGB(255, 148, 185, 255)
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
