import 'message_type.dart';
import 'game_info.dart';
import 'member.dart';

class Message {
  MessageType type;
  String roomId;
  String sessionId;
  GameInfo gameInfo;
  List<MemberInfo> memberInfos;
  String poll;

  Message(
      {this.type,
      this.roomId,
      this.sessionId,
      this.gameInfo,
      this.memberInfos,
      this.poll});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        type: MessageType.values.firstWhere(
            (type) => type.toString() == 'MessageType.${json["type"]}',
            orElse: () => null),
        roomId: json['roomId'] as String,
        sessionId: json['sessionId'] as String,
        gameInfo: GameInfo.fromJson(json['gameInfo'] as Map<String, dynamic>),
        memberInfos: (json['memberInfos'] as List<dynamic>)
            ?.map((memberInfos) => MemberInfo.fromJson(memberInfos))
            ?.toList(),
        poll: json['poll'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'roomId': roomId,
      'sessionId': sessionId,
      'gameInfo': gameInfo?.toJson(),
      'memberInfos':
          memberInfos?.map((memberInfos) => memberInfos.toJson())?.toList(),
      'poll': poll
    };
  }
}
