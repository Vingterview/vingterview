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
  bool isParticipant = false;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6fa8dc), Color(0xFF8A61D4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Q. ${widget.client.state.gameInfo.question[widget.client.state.gameInfo.round - 1]}",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 15),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 220,
                      height: 300,
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
                        width: 204,
                        height: 204,
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
                    Positioned(
                      bottom: 16,
                      child: ElevatedButton(
                        onPressed: isParticipant
                            ? null
                            : () {
                                widget.client
                                    .sendMessage(MessageType.PARTICIPATE);
                                setState(() {
                                  isParticipant = true;
                                });
                              },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15.0),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            isParticipant ? Colors.grey : Colors.black38,
                          ),
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
                        child: Text(isParticipant ? '참가 완료' : '참가하기',
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

Widget getStage3(WebSocketClient client) {
  return Page3(client: client);
}
