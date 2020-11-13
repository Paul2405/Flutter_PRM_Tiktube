import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/VideoBloc/VideoBloc.dart';
import 'package:flutter_app/Layout/Detail/Detail_media.dart';
import 'package:flutter_app/Layout/HomePage/Generate_List_Video.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:videos_player/model/control.model.dart';
import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/videos_player.dart';

class homeWidget extends StatefulWidget {
  final int pageSize;
  final int pageNum;

  const homeWidget({Key key, this.pageSize, this.pageNum}) : super(key: key);

  @override
  _homeWidgetState createState() => _homeWidgetState(pageSize, pageNum);
}

class _homeWidgetState extends State<homeWidget> {
  int pageSize;
  int pageNum;

  _homeWidgetState(this.pageSize, this.pageNum);

  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    videoBloc.resetListVideos();
    _getMoreVideo();
    _refreshController = RefreshController();
  }

  //_getMoreVideo()
  void _getMoreVideo() async {
    videoBloc.getListVideos(pageSize, pageNum);
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
        StreamBuilder<List<Video>>(
          stream: videoBloc.listVideo,
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
                            print(listVideo[index].id),
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
