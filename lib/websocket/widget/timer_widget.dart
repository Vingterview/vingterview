import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimerWidget extends StatefulWidget {
  final int secondsRemaining;

  TimerWidget({this.secondsRemaining});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int secondsRemaining;
  Timer timer;

  @override
  void initState() {
    super.initState();
    secondsRemaining = widget.secondsRemaining;
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      secondsRemaining = widget.secondsRemaining;
      startTimer();
    }
  }

  void startTimer() {
    if (secondsRemaining == null) {
      return;
    }
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          print(secondsRemaining);
          secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  ///여기에 시계 그려서 쓰면 됩니다
  @override
  Widget build(BuildContext context) {
    return Text(
      'Remaining Time: $secondsRemaining seconds',
      style: TextStyle(fontSize: 16),
    );
  }
}
