import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/VideoBloc/VideoBloc.dart';
import 'package:flutter_app/Layout/Detail/Detail_media.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:videos_player/model/control.model.dart';
import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/videos_player.dart';

class generateListVideo extends StatefulWidget {
  final String searchValue;
  final int pageSize;
  final int pageNum;

  const generateListVideo({Key key, this.pageSize, this.pageNum, this.searchValue}) : super(key: key);

  @override
  _generateListVideo createState() => _generateListVideo(pageSize, pageNum, searchValue);
}

class _generateListVideo extends State<generateListVideo> {
  int pageSize;
  int pageNum;
  String searchValue;
  bool isSearching = false;
  bool isNull = true;
  _generateListVideo(this.pageSize, this.pageNum, this.searchValue);

  RefreshController _refreshController = RefreshController();
  TextEditingController _searchValue = new TextEditingController();

  @override
  void initState() {
    super.initState();
    videoBloc.resetListVideos();
    _getMoreVideo();
    _refreshController = RefreshController();
  }

  //_getMoreVideo()
  void _getMoreVideo() async {
    videoBloc.searchVideoByTitle(searchValue, pageSize,pageNum);
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
    _searchValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        iconTheme: IconThemeData(color: Colors.black87),
        title: !isSearching
            ? Text('TikTube', style: TextStyle(color: Colors.blueGrey[800]),)
            : TextField(
          onChanged: (text){
            if(text.isNotEmpty){
              setState(() {
                this.isNull = false;
              });
            }else{
              setState(() {
                this.isNull = true;
              });
            }
          },
          controller: _searchValue,
          style: TextStyle(color: Colors.blueGrey),
          decoration: InputDecoration(
              hintText: "Search video",
              hintStyle: TextStyle(color: Colors.blueGrey)),
        ),
        actions: <Widget>[
          isSearching
              ? isNull ? IconButton(
            icon: Icon(Icons.cancel_outlined, color: Colors.black87,),
            onPressed: () {
              setState(() {
                this.isSearching = false;
              });
            },
          ): IconButton(
            icon: Icon(Icons.search, color: Colors.black87,),
            onPressed: () {
              videoBloc.resetListVideosSearch();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      generateListVideo(searchValue: _searchValue.text,pageSize: 3,pageNum: 1,),
                ),
              );
            },
          )
              : IconButton(
            icon: Icon(Icons.search, color: Colors.black87,),
            onPressed: () {
              setState(() {
                this.isSearching = true;
              });
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<Video>>(
            stream: videoBloc.searchVideo,
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
      ),
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
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
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
        width: MediaQuery.of(context).size.width,
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
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detailMedia(
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
