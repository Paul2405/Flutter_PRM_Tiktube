
import 'dart:convert';
import 'package:http/http.dart' as http;

class RepositoryDelete{
  static String mainUrl = "http://scamv2.azurewebsites.net";
  var deleteLikeUrl = "$mainUrl/api/Videos/Like";
  var deleVideobyIDUrl = "$mainUrl/api/Videos/";

  Future<bool> deleteLike(int id) async{
    final respone =  await http.delete(deleteLikeUrl+ "/$id");
    if(respone.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> deleteVideoById(int id) async{
    final respone =  await http.delete(deleVideobyIDUrl+ "/$id");
    if(respone.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
}
final deleteRepo =  RepositoryDelete();