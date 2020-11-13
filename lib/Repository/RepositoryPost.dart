import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:flutter_app/Model/Video/Comment.dart';
import 'package:flutter_app/Model/Video/Like.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class RepositoryPost{
  static String mainUrl = "http://scamv2.azurewebsites.net";
  var postVideoUrl = "$mainUrl/api/Videos";
  var postCommentUrl = "$mainUrl/api/Videos/Comment";
  var postLikeUrl = "$mainUrl/api/Videos/Like";

  Future<dynamic> postVideo(Video video) async{
    String body = videoToJson(video);
    print("------------------body: $body");
    var response = await http.post(postVideoUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    if(response.statusCode == 201){
      print(response.statusCode);
      return response.statusCode;
    }else{
      print(response.statusCode);
      return response.statusCode;
    }
  }

  Future<dynamic> postComment(Comment comment) async{
    String body = commentToJson(comment);
    print(body);
    var response = await http.post(postCommentUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    if(response.statusCode == 200){
      print(response.body);
      return response.statusCode;
    }else{
      print(response.statusCode);
      return response.statusCode;
    }
  }
  Future<dynamic> postLike(Like like) async{
    String body = likeToJson(like);
    print(body);
    var response = await http.post(postLikeUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    if(response.statusCode == 200){
      print(response.body);
      return response.statusCode;
    }else{
      print(response.statusCode);
      return response.statusCode;
    }
  }
}
final postRepo = RepositoryPost();