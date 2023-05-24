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
        boardId: json['board_id'],
        questionId: json['question_id'],
        questionContent: json['question_content'],
        memberId: json['member_id'],
        memberName: json['member_nickname'],
        profileUrl: json['profile_image_url'],
        content: json['content'],
        videoUrl: json['video_url'],
        likeCount: json['like_count'],
        commentCount: json['comment_count'],
        createTime: json['create_time'],
        updateTime: json['update_time']);
  }

  Map<String, dynamic> toJson() {
    return {
      'board_id': boardId,
      'question_id': questionId,
      'question_content': questionContent,
      'member_id': memberId,
      'member_nickname': memberName,
      'profile_image_url': profileUrl,
      'content': content,
      'video_url': videoUrl,
      'like_count': likeCount,
      'comment_count': commentCount,
      'create_time': createTime,
      'update_time': updateTime,
    };
  }
}
