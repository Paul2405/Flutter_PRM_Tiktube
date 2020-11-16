import 'package:flutter/material.dart';
import 'package:flutter_app/Model/Video/Comment.dart';
import 'package:flutter_app/Model/Video/Like.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'package:flutter_app/Repository/RepositoryGet.dart';
import 'package:rxdart/rxdart.dart';

class VideoBloc {
  Repository _repository = new Repository();
  final BehaviorSubject<List<Video>> _videoBehavior =
      new BehaviorSubject<List<Video>>();
  final BehaviorSubject<List<Video>> _searchVideo =
  new BehaviorSubject<List<Video>>();
  final BehaviorSubject<List<Comment>> _commentVideo =
  new BehaviorSubject<List<Comment>>();
  final BehaviorSubject<List<Video>> _videoOfUser =
  new BehaviorSubject<List<Video>>();


  final List<Video> listResult = [];
  final List<Video> listSearch = [];
  final List<Comment> listComment = [];
  final List<Video> listVideoByUserId = [];
  bool  isLike = false;
  Video video;

  getVideoByUserID(int userID, int pageSize, int pageNum) async{
    List<Video> result =  await _repository.getVideoByUserID(userID, pageSize, pageNum);
    for(Video v in result){
      if(v.status == true){
        listVideoByUserId.add(v);
      }
    }
    _videoOfUser.sink.add(listVideoByUserId);
  }
  getVideoByID(int id) async{
    video = await _repository.getVideobyID(id);
    return video;
  }
  getCommentByVideoID(int videoID, int pageSize, int pageNum) async{
    List<Comment> _comment = await _repository.getCommentVideo(videoID, pageSize, pageNum);
    for(Comment c in _comment){
      listComment.add(c);
      print(c.conttent);
    }
    _commentVideo.sink.add(listComment);
  }

  checkVideoLikebyUserId(int id, int userId) async{
    List<Like> temp = await _repository.getVideoLike(id);
    print("____________${temp.length}");
    if(temp.where((element) => element.userId == userId && element.status == true).isNotEmpty){
      print("____________${temp.length}");
      isLike = true;
    }else{
      isLike = false;
    }
    return isLike;
  }

  getLikeID(int id, int userID) async{
    int likeId =  -1;
    List<Like> temp =  await _repository.getVideoLike(id);
    print(temp.length);
    if(temp.where((element) => element.userId == userID && element.status == true).isNotEmpty){
      print("i am here");
      likeId = temp.where((element) => element.userId == userID).first.id;
      print("$likeId");
    }
    return likeId;
  }

  getListVideos(int pageSize, int pageNum) async {
    List<Video> _video = await _repository.getVideos(pageSize, pageNum);
    for(Video v in _video){
      if(v.status == true){
        listResult.add(v);
      }
    }
    _videoBehavior.sink.add(listResult);
  }

  getListVideosByUser(int userID,int pageSize, int pageNum) async {
    List<Video> _video = await _repository.getVideos(pageSize, pageNum);
    for(Video v in _video){
      listResult.add(v);
    }
    _videoBehavior.sink.add(listResult);
  }

  searchVideoByTitle(String searchValue, int pageSize, int pageNum ) async{
    List<Video> _video = await _repository.searchVideo(searchValue, pageSize, pageNum);
    for(Video v in _video){
      listSearch.add(v);
      print(v.title);
    }
    _searchVideo.sink.add(listSearch);
  }

  resetListVideos(){
    listResult.clear();
  }
  resetListVideosByUserId(){
    listVideoByUserId.clear();
  }
  resetListVideosSearch(){
    listSearch.clear();
  }

  resetListCommentVideos(){
    listComment.clear();
  }

  dispose() {
    _videoBehavior.close();
    _searchVideo.close();
    _commentVideo.close();
    _videoOfUser.close();
  }

  BehaviorSubject<List<Video>> get listVideo => _videoBehavior.stream;
  BehaviorSubject<List<Video>> get searchVideo => _searchVideo.stream;
  BehaviorSubject<List<Comment>> get listCommentVideo => _commentVideo.stream;
  BehaviorSubject<List<Video>> get listVideoOfUserID => _videoOfUser.stream;

}

final videoBloc = VideoBloc();


