import 'dart:convert';

Video videoFromJson(String str) => Video.fromJson(json.decode(str));

String videoToJson(Video data) => json.encode(data.toJson());

class Video {
  Video({
    this.id,
    this.title,
    this.decription,
    this.userId,
    this.urlShare,
    this.likeCount,
    this.commentCount,
    this.status,
    this.user,
  });

  int id;
  String title;
  String decription;
  int userId;
  String urlShare;
  int likeCount;
  int commentCount;
  bool status;
  dynamic user;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    title: json["title"],
    decription: json["decription"],
    userId: json["userId"],
    urlShare: json["urlShare"],
    likeCount: json["likeCount"],
    commentCount: json["commentCount"],
    status: json["status"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "decription": decription,
    "userId": userId,
    "urlShare": urlShare,
    "likeCount": likeCount,
    "commentCount": commentCount,
    "status": status,
    "user": user,
  };
}
