import 'dart:convert';
import 'tags.dart';
import 'package:http/http.dart' as http;

class Questions {
  final int questionId;
  final String questionContent;
  final int scrapCount;
  final int commentCount;
  final String createTime;
  final int boardCount;
  final List<Tags> tags;

  Questions({
    this.questionId,
    this.questionContent,
    this.scrapCount,
    this.commentCount,
    this.createTime,
    this.boardCount,
    this.tags,
  });

  factory Questions.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonTags = json['tags'];
    // print(jsonTags);
    List<Tags> _tags = jsonTags != null
        ? jsonTags.map((tag) => Tags.fromJson(tag)).toList()
        : [];
    return Questions(
        questionId: json['question_id'],
        questionContent: json['question_content'],
        scrapCount: json['scrap_count'],
        commentCount: json['comment_count'],
        createTime: json['create_time'],
        boardCount: json['board_count'],
        tags: _tags);
  }
}
