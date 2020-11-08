import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.fullname,
    this.avatarUrl,
    this.phone,
    this.birthday,
    this.email,
    this.creationDate,
    this.video,
  });

  int id;
  String fullname;
  String avatarUrl;
  dynamic phone;
  dynamic birthday;
  String email;
  dynamic creationDate;
  dynamic video;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullname: json["fullname"],
    avatarUrl: json["avatarUrl"],
    phone: json["phone"],
    birthday: json["birthday"],
    email: json["email"],
    creationDate: DateTime.parse(json["creationDate"]),
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullname": fullname,
    "avatarUrl": avatarUrl,
    "phone": phone,
    "birthday": birthday,
    "email": email,
    "creationDate": creationDate.toIso8601String(),
    "video": video,
  };
}