import 'dart:convert';

import 'package:flutter_app/Model/User/User_Model.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    this.userId,
    this.videoId,
    this.conttent,
    this.status,
    this.user,
  });

  int userId;
  int videoId;
  String conttent;
  bool status;
  User user;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    userId: json["userId"],
    videoId: json["videoId"],
    conttent: json["conttent"],
    status: json["status"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "videoId": videoId,
    "conttent": conttent,
    "status": status,
  };
}
