import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/VideoBloc/VideoBloc.dart';
import 'package:flutter_app/Layout/Detail/Detail_media.dart';
import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'package:flutter_app/Repository/RepositoryDelete.dart';
import 'package:flutter_app/Repository/RepositoryPut.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:videos_player/model/control.model.dart';
import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/videos_player.dart';

class VideoOfUser extends StatefulWidget {
  final int pageSize;
  final int pageNum;

  const VideoOfUser({Key key, this.pageSize, this.pageNum}) : super(key: key);

  @override
  _videoOfUserState createState() => _videoOfUserState(pageSize, pageNum);
}

class _videoOfUserState extends State<VideoOfUser> {
  int pageSize;
  int pageNum;

  _videoOfUserState(this.pageSize, this.pageNum);

  RefreshController _refreshController = RefreshController();
  LocalStorage _storage = LocalStorage('user');
  TextEditingController _title;
  TextEditingController _decription;

  @override
  void initState() {
    super.initState();
    videoBloc.resetListVideosByUserId();
    _getMoreVideo();
    _refreshController = RefreshController();
  }

  //_getMoreVideo()
  void _getMoreVideo() async {
    videoBloc.getVideoByUserID(User.fromJson(_storage.getItem('user')).id,pageSize, pageNum);
    if (mounted) {
      _refreshController.loadComplete();
      pageNum++;
    }
  }

  void _onLoading() {
    Future.delayed(const Duration(milliseconds: 2009)).then((val) {
      _getMoreVideo();
    });
  }

  //dispose
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("My video", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blueGrey),),
          ),
        ),
        StreamBuilder<List<Video>>(
          stream: videoBloc.listVideoOfUserID,
          builder: (context, AsyncSnapshot<List<Video>> snapshot) {
            if (snapshot.hasData) {
              return _buildGenresWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.0,
              width: 25.0,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.blueAccent),
                strokeWidth: 4.0,
              ),
            )
          ],
        ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error"),
          ],
        ));
  }

  Widget _buildGenresWidget(List<Video> data) {
    List<Video> listVideo = data;
    if (listVideo.length == 0) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "list video empty",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Flexible(
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView.builder(
              itemCount: listVideo.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(4.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: InkWell(
                          onTap: () =>
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        detailMedia(
                                          detailsVideo: listVideo[index],
                                        )))
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: VideosPlayer(
                                  networkVideos: [
                                    new NetworkVideo(
                                      videoUrl: listVideo[index].urlShare,
                                      videoControl: new NetworkVideoControl(
                                          autoPlay: false),
                                    )
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(listVideo[index].title),
                                subtitle: Text(listVideo[index].decription),
                              ),
                              Row(
                                children: [
                                  TextButton(onPressed: (){
                                    _title = new TextEditingController(text: listVideo[index].title.trim());
                                    _decription = new TextEditingController(text: listVideo[index].decription.trim());
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Edit video"),
                                            content: Container(
                                              height: 150,
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    controller: _title,
                                                    decoration: InputDecoration(
                                                        labelText: "Title"),
                                                  ),
                                                  TextField(
                                                    controller: _decription,
                                                    decoration:
                                                    InputDecoration(labelText: "Decription"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, false);
                                                    },
                                                  child: Text("Cancel".toUpperCase())),
                                              TextButton(
                                                  onPressed: () async {
                                                   int status = await putRepo.updateVideo(new Video(
                                                      id: listVideo[index].id,
                                                      status: listVideo[index].status,
                                                      commentCount: listVideo[index].commentCount,
                                                      likeCount: listVideo[index].likeCount,
                                                      title: _title.text.trim(),
                                                      decription: _decription.text.trim(),
                                                      userId: User.fromJson(_storage.getItem('user')).id,
                                                      urlShare: listVideo[index].urlShare,
                                                    ));
                                                   if(status == 204){
                                                     setState(() {
                                                       listVideo[index].title = _title.text.trim();
                                                       listVideo[index].decription = _decription.text.trim();
                                                     });
                                                     Navigator.pop(context, false);
                                                   }
                                                  },
                                                  child: Text("Update".toUpperCase()))
                                            ],
                                          );
                                        });
                                  }, child: Text("Update")),
                                  TextButton(onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Delete video"),
                                            content: Container(
                                              child: Text("Are you sure delete this video?"),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, false);
                                                  },
                                                  child: Text("Cancel".toUpperCase())),
                                              TextButton(
                                                  onPressed: () async {
                                                    bool check;
                                                    await deleteRepo.deleteVideoById(listVideo[index].id).then((value) => check = value);
                                                    if(check){
                                                      setState(() {
                                                        listVideo.removeAt(index);
                                                      });
                                                      Navigator.pop(context, false);
                                                    }
                                                    else{
                                                      Navigator.pop(context, false);
                                                    }
                                                  },
                                                  child: Text("Delete".toUpperCase()))
                                            ],
                                          );
                                        });
                                  }, child: Text("Delete")),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      );
    }
  }
}
