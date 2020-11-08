import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Repository {
  static String mainUrl = "http://scamv2.azurewebsites.net";
  var getUser = "$mainUrl/api/Users/";
  var postUser = "$mainUrl/api/Users/auth";
  var getVideosUrl = "$mainUrl/api/videos";
  var search = "$mainUrl/api/Videos/title";

  Future<User> getUserByID(int id) async {
    final response = await http.get(postUser + '$id');
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



}
