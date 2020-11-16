import 'dart:convert';
import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'package:http/http.dart' as http;

class RepositoryPut {
  static String mainUrl = "http://scamv2.azurewebsites.net";
  var putUrl = "$mainUrl/api/Users";
  var updateVideoUrl = "$mainUrl/api/Videos";

  Future<dynamic> updateUserByID(User user) async {
    String body = userToJson(user);
    print("------------------body: $body");
    var response = await http.put(putUrl + "/${user.id}", body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    if (response.statusCode == 204) {
      print(response.statusCode);
      return response.statusCode;
    } else {
      print(response.statusCode);
      return response.statusCode;
    }
  }

  Future<dynamic> updateVideo(Video video) async {
    String body = videoToJson(video);
    print("------------------body: $body");
    var response = await http.put(updateVideoUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    if (response.statusCode == 204) {
      print(response.statusCode);
      return response.statusCode;
    } else {
      print(response.statusCode);
      return response.statusCode;
    }
  }
}

final putRepo = RepositoryPut();
