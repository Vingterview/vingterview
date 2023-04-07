import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Board'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text('Welcome to the Board page!'),
          ),
        ));
  }
}
