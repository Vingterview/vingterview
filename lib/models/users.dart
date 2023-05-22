import 'dart:convert';

import 'package:http/http.dart' as http;

class Users {
  final int member_id;
  final String id;
  final String name;
  final int age;
  final String email;
  final String nickName;
  final String profile_image_url;

  Users(
      {this.member_id,
      this.id,
      this.name,
      this.age,
      this.email,
      this.nickName,
      this.profile_image_url});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        member_id: json['member_id'],
        id: json['id'],
        name: json['name'],
        age: json['age'],
        email: json['email'],
        nickName: json['nickname'],
        profile_image_url: json['profile_image_url']);
  }
}
