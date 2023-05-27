import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'package:capston/websocket/message/message_type.dart';

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
          Row(
            children: [
              for (var memberInfo in widget.client.state.memberInfos)
                Column(
                  children: [
                    Text(memberInfo.name),
                    Image.network(memberInfo.encodedImage),
                  ],
                ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("가장 잘한 참가자를 선택해주세요!"),
                for (var value in buttonValues)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: (selectedValue == value)
                          ? MaterialStateProperty.all<Color>(Colors.blue)
                          : null,
                    ),
                    child: Text(value),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (selectedValue != null)
                      ? () {
                          // Provider.of<GameState>(context, listen: false).poll =
                          //     selectedValue;
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
      ..color = Colors.red
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    double radius = min(size.width, size.height) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);
    double angle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      -angle,
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
