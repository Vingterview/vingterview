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
  final String create;
  final String update;

  Comments({
    this.commentId,
    this.boardId,
    this.memberId,
    this.memberNickname,
    this.profileUrl,
    this.content,
    this.likeCount,
    this.create,
    this.update,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
        commentId: json['comment_id'],
        boardId: json['board_id'],
        memberId: json['member_id'],
        memberNickname: json['member_nickname'],
        profileUrl: json['profile_image_url'],
        content: json['content'],
        likeCount: json['like_count'],
        create: json['create_time'],
        update: json['update_time']);
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'board_id': boardId,
      'member_id': memberId,
      'member_nickname': memberNickname,
      'profile_image_url': profileUrl,
      'content': content,
      'like_count': likeCount,
      'create_time': create,
      'update_time': update,
    };
  }
}
