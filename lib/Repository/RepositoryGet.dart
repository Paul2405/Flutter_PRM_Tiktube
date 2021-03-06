import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:flutter_app/Model/Video/Comment.dart';
import 'package:flutter_app/Model/Video/Like.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Repository {
  static String mainUrl = "http://scamv2.azurewebsites.net";
  var getUser = "$mainUrl/api/Users/";
  var postUser = "$mainUrl/api/Users/auth";
  var getVideosUrl = "$mainUrl/api/videos";
  var search = "$mainUrl/api/Videos/title";
  var getCommentUrl = "$mainUrl/api/Videos";
  var getVideoLikeUrl = "$mainUrl/api/Videos";
  var getVideoUrl = "$mainUrl/api/Videos";
  var getVideoByUserIDURL = "$mainUrl/api/Users";

  Future<List<Video>> getVideoByUserID(int userId, int pageSize, int pageNum) async{
    final response =  await http.get(getVideoByUserIDURL+ "/$userId/Video?pageSize=$pageSize&pageNum=$pageNum");
    print("__________xxx$getVideoByUserIDURL/$userId/Video?pageSize=$pageSize&pageNum=$pageNum");
    if(response.statusCode == 200){
      return json
          .decode(response.body)
          .map<Video>((item) => Video.fromJson(item))
          .toList();
    }else{
      throw Exception("fail to get video by userID");
    }
  }
  Future<User> getUserByID(int id) async {
    final response = await http.get(getUser + '$id');
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception("fail to get user");
    }
  }

  Future<User> login(String token) async {
    final response = await http.post(postUser + "?jwt=$token");
    if (response.statusCode == 200) {
      print(response.statusCode);
      return User.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
      throw Exception("fail to get User");
    }
  }

  Future<List<Video>> getVideos(int pageSize, int pageNum) async{
    final response = await http.get(getVideosUrl + "?pageSize=$pageSize&pageNum=$pageNum");
    if(response.statusCode == 200){
      return json
          .decode(response.body)
          .map<Video>((item) => Video.fromJson(item))
          .toList();
    }else{
      throw Exception("fail to get videos");
    }
  }

  Future<List<Video>> searchVideo(String searchValue, int pageSize, int pageNum) async{
    final response = await http.get(search + "?title=$searchValue&pageSize=$pageSize&pageNum=$pageNum");
    if(response.statusCode == 200){
      return json
          .decode(response.body)
          .map<Video>((item) => Video.fromJson(item))
          .toList();
    }else{
      throw Exception("fail to get videos");
    }
  }
  
  Future<dynamic> getCommentVideo(int id, int pageSize, int pageNum) async {
    final response = await http.get(getCommentUrl+"/$id/Comment?pageSize=$pageSize&pageNum=$pageNum");
    if(response.statusCode == 200){
      return json
          .decode(response.body)
          .map<Comment>((item) => Comment.fromJson(item))
          .toList();
    }else{
      throw Exception('fail to get comment fail');
    }
  }
  
  Future<dynamic> getVideoLike(int id) async{
    final response = await http.get(getVideoLikeUrl + "/$id/Like");
    if(response.statusCode == 200){
      return json
          .decode(response.body)
          .map<Like>((item) => Like.fromJson(item))
          .toList();
    }else{
      throw Exception("fail to get video like");
    }
  }
  Future<Video> getVideobyID(int id) async{
    final respone = await http.get(getVideoUrl +"/$id");
    if(respone.statusCode == 200){
      return videoFromJson(respone.body);
    }else{
      throw Exception("fail to get Video by id");
    }
  }
}
final repository = Repository();
