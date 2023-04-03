import 'dart:convert';

import 'package:http/http.dart' as http;

class Users {
  final int id;
  final String userId;
  final String password;
  final String name;
  final int age;
  final String nickName;
  final String createTime;
  final String updateTime;

  Users({this.id, this.userId, this.password, this.name, this.age, this.nickName, this.createTime, this.updateTime});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      userId: json['userId'],
      password: json['password'],
      name: json['name'],
      age: json['age'],
      nickName: json['nickName'],
      createTime: json['createTime'],
      updateTime: json['updateTime']
    );
  }
}
