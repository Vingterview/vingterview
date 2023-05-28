import 'package:flutter/cupertino.dart';
import '../message/member.dart';

import '../message/game_info.dart';
import 'stage.dart';

class GameState with ChangeNotifier {
  Stage stage;
  String sessionId;
  String roomId;
  String agoraToken;
  List<MemberInfo> memberInfos;
  GameInfo gameInfo = GameInfo();
  String currentBroadcaster;
  String poll;
  int duration;

  notifyState(Stage stage) {
    this.stage = stage;
    notifyListeners();
  }
}
