import 'dart:convert';
import 'tags.dart';
import 'package:http/http.dart' as http;

class Questions {
  final int questionId;
  final String questionContent;
  final int scrapCount;
  final int commentCount;
  final DateTime createTime;
  final List<Tags> tags;

  Questions({
    this.questionId,
    this.questionContent,
    this.scrapCount,
    this.commentCount,
    this.createTime,
    this.tags,
  });

  factory Questions.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonTags = json['tags'];
    List<Tags> _tags = jsonTags.map((tag) => Tags.fromJson(tag)).toList();
    return Questions(
        questionId: json['questionId'],
        questionContent: json['questionContent'],
        scrapCount: json['scrapCount'],
        commentCount: json['commentCount'],
        createTime: json['createTime'],
        tags: _tags);
  }
}
