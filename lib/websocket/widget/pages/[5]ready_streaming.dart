import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capston/websocket/wsclient/game_state.dart';
import '../timer_widget.dart';
import 'package:capston/websocket/wsclient/websocket_client.dart';
import 'package:capston/websocket/message/message_type.dart';
import 'streaming_page.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'dart:convert';

class Page5 extends StatefulWidget {
  final WebSocketClient client;

  Page5({this.client});

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }
}

Widget getStage5(WebSocketClient client) {
  return Page5(client: client);
}
