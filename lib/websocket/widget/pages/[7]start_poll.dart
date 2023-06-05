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
  List<String> buttonNames = [];
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
    buttonValues = widget.client.state.gameInfo.participant;

    //  buttonValues = widget.client.state.gameInfo.order;
    // for (var memberInfo in widget.client.state.memberInfos) {
    //   if (widget.client.state.gameInfo.participant
    //       .contains(memberInfo.sessionId)) {
    //     buttonNames.add(memberInfo.name);
    //   }
    // }

    for (var value in buttonValues) {
      for (var memberInfo in widget.client.state.memberInfos) {
        if (value == memberInfo.sessionId) {
          buttonNames.add(memberInfo.name);
        }
      }
    }
    setState(() {});
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
                  '''가장 잘한 참가자를 선택해주세요!''',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int index = 0; index < buttonValues.length; index++)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0), // 버튼들 사이 간격 조절
                        child: ElevatedButton(
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
                                MaterialStateProperty.resolveWith<Color>(
                              (states) {
                                if (selectedValue == buttonValues[index]) {
                                  return Color(0xFF8A61D4); // 선택된 버튼 파란색
                                } else {
                                  return Colors.black38; // 비활성화된 버튼 회색
                                } // 기본 버튼 스타일
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            overlayColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color: Color(0xFF8A61D4),
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            buttonNames[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (selectedValue != null && !isPolled)
                      ? () {
                          widget.client.state.poll = selectedValue;
                          widget.client.sendMessage(MessageType.POLL);
                          print(widget.client.state.poll);

                          setState(() {
                            isPolled = true;
                          });
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
