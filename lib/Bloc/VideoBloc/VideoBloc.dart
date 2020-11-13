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


  final List<Video> listResult = [];
  final List<Video> listSearch = [];
  final List<Comment> listComment = [];
  bool  isLike = false;
  Video video;
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
    print("_______$temp");
    print("_______________${temp.where((element) => element.userId == userId).isNotEmpty}");
    if(temp.where((element) => element.userId == userId).isNotEmpty){
      isLike = true;
    }else{
      isLike = false;
    }
    return isLike;
  }

  getListVideos(int pageSize, int pageNum) async {
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
  }

  BehaviorSubject<List<Video>> get listVideo => _videoBehavior.stream;
  BehaviorSubject<List<Video>> get searchVideo => _searchVideo.stream;
  BehaviorSubject<List<Comment>> get listCommentVideo => _commentVideo.stream;

}

final videoBloc = VideoBloc();


