import 'package:flutter_app/Model/Video/Video.dart';
import 'package:flutter_app/Repository/Repository.dart';
import 'package:rxdart/rxdart.dart';

class VideoBloc {
  Repository _repository = new Repository();
  final BehaviorSubject<List<Video>> _videoBehavior =
      new BehaviorSubject<List<Video>>();
  final BehaviorSubject<List<Video>> _searchVideo =
  new BehaviorSubject<List<Video>>();

  final List<Video> listResult = [];
  final List<Video> listSearch = [];
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

  dispose() {
    _videoBehavior.close();
    _searchVideo.close();
  }

  BehaviorSubject<List<Video>> get listVideo => _videoBehavior.stream;
  BehaviorSubject<List<Video>> get searchVideo => _searchVideo.stream;
}

final videoBloc = VideoBloc();
