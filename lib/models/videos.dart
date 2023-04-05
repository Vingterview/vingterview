import 'dart:convert';

import 'package:http/http.dart' as http;

class Videos {
  final int boardId;
  final int questionId;
  final String questionContent;
  final int memberId;
  final String memberName;
  final String profileUrl;
  final String content;
  final String videoUrl;
  final int likeCount;
  final int commentCount;
  final String createTime;
  final String updateTime;

  Videos({
    this.boardId,
    this.questionId,
    this.questionContent,
    this.memberId,
    this.memberName,
    this.profileUrl,
    this.content,
    this.videoUrl,
    this.likeCount,
    this.commentCount,
    this.createTime,
    this.updateTime,
  });

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
        boardId: json['boardId'],
        questionId: json['questionId'],
        questionContent: json['questionContent'],
        memberId: json['memberId'],
        memberName: json['memberName'],
        profileUrl: json['profileUrl'],
        content: json['content'],
        videoUrl: json['videoUrl'],
        likeCount: json['likeCount'],
        commentCount: json['commentCount'],
        createTime: json['createTime'],
        updateTime: json['updateTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'boardId': boardId,
      'questionId': questionId,
      'questionContent': questionContent,
      'memberId': memberId,
      'memberName': memberName,
      'profileUrl': profileUrl,
      'content': content,
      'videoUrl': videoUrl,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}
