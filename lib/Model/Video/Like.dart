
import 'dart:convert';

import 'package:flutter_app/Model/User/User_Model.dart';

List<Like> likeFromJson(String str) => List<Like>.from(json.decode(str).map((x) => Like.fromJson(x)));

String likesToJson(List<Like> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
String likeToJson(Like data) => json.encode(data.toJson());

class Like {
  Like({
    this.userId,
    this.videoId,
    this.status,
    this.id,
    this.user,
    this.video,
  });

  int userId;
  int videoId;
  bool status;
  int id;
  User user;
  dynamic video;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    userId: json["userId"],
    videoId: json["videoId"],
    status: json["status"],
    id: json["id"],
    user: User.fromJson(json["user"]),
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "videoId": videoId,
    "status": status,
  };
}

