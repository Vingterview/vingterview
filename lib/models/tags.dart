import 'dart:convert';

import 'package:http/http.dart' as http;

class Tags {
  final int tagId;
  final String tagName;

  Tags({
    this.tagId,
    this.tagName,
  });

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
      tagId: json['tag_id'],
      tagName: json['tag_name'],
    );
  }
}
