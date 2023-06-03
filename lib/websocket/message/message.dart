import 'message_type.dart';
import 'game_info.dart';
import 'member.dart';

class Message {
  MessageType type;
  String roomId;
  String sessionId;
  String currentBroadcaster;
  GameInfo gameInfo;
  List<MemberInfo> memberInfos;
  String poll;
  String agoraToken;

  Message(
      {this.type,
      this.roomId,
      this.sessionId,
      this.currentBroadcaster,
      this.gameInfo,
      this.memberInfos,
      this.poll,
      this.agoraToken});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      type: MessageType.values.firstWhere(
          (type) => type.toString() == 'MessageType.${json["type"]}',
          orElse: () => null),
      roomId: json['roomId'] as String,
      sessionId: json['sessionId'] as String,
      currentBroadcaster: json['currentBroadcaster'] as String,
      gameInfo: GameInfo.fromJson(json['gameInfo'] as Map<String, dynamic>),
      memberInfos: (json['memberInfos'] as List<dynamic>)
          ?.map((memberInfos) => MemberInfo.fromJson(memberInfos))
          ?.toList(),
      poll: json['poll'] as String,
      agoraToken: json['agoraToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'roomId': roomId,
      'sessionId': sessionId,
      'currentBroadcaster': currentBroadcaster,
      'gameInfo': gameInfo?.toJson(),
      'memberInfos':
          memberInfos?.map((memberInfos) => memberInfos.toJson())?.toList(),
      'poll': poll,
      'agoraToken': agoraToken,
    };
  }
}
