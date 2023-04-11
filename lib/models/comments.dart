import 'dart:convert';

import 'package:http/http.dart' as http;

class Comments {
  final int commentId;
  final int boardId;
  final int memberId;
  final String memberNickname;
  final String profileUrl;
  final String content;
  final int likeCount;

  Comments({
    this.commentId,
    this.boardId,
    this.memberId,
    this.memberNickname,
    this.profileUrl,
    this.content,
    this.likeCount,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      commentId: json['comment_id'],
      boardId: json['board_id'],
      memberId: json['member_id'],
      memberNickname: json['member_nickname'],
      profileUrl: json['profile_url'],
      content: json['content'],
      likeCount: json['like_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'board_id': boardId,
      'member_id': memberId,
      'member_nickname': memberNickname,
      'profile_url': profileUrl,
      'content': content,
      'like_count': likeCount,
    };
  }
}
