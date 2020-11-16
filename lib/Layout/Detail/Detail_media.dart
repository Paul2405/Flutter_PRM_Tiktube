import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/VideoBloc/VideoBloc.dart';
import 'package:flutter_app/Layout/HomePage/Generate_List_Video.dart';
import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:flutter_app/Model/Video/Comment.dart';
import 'package:flutter_app/Model/Video/Like.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'package:flutter_app/Repository/RepositoryDelete.dart';
import 'package:flutter_app/Repository/RepositoryPost.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:videos_player/model/control.model.dart';
import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/videos_player.dart';

// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

class detailMedia extends StatefulWidget {
  final Video detailsVideo;

  const detailMedia({Key key, this.detailsVideo}) : super(key: key);

  @override
  _detailMediaState createState() => _detailMediaState(detailsVideo);
}

class _detailMediaState extends State<detailMedia> {
  Video detailsVideo;
  int pageSize = 5;
  int pageNum = 1;

  _detailMediaState(this.detailsVideo);

  TextEditingController _comment = new TextEditingController();
  TextEditingController _searchValue = new TextEditingController();
  RefreshController _refreshController = RefreshController();
  final LocalStorage storage = LocalStorage('user');

  bool isSearching = false;
  bool isNull = true;
  Color color = Colors.black87;
  Color like = Colors.red;
  bool isLike = false;

  void _onLoading() {
    Future.delayed(const Duration(milliseconds: 2009)).then((val) {
      _getMoreCommentVideo();
    });
  }

  void _getMoreCommentVideo() async {
    videoBloc.getCommentByVideoID(detailsVideo.id, pageSize, pageNum);
    if (mounted) {
      _refreshController.loadComplete();
      pageNum++;
    }
  }
  void getVideo() async{
    Video video =  await videoBloc.getVideoByID(detailsVideo.id);
    bool isLiked =  await videoBloc.checkVideoLikebyUserId(
        detailsVideo.id, User.fromJson(storage.getItem('user')).id);
    if(mounted){
      setState(() {
        detailsVideo = video;
        isLike = isLiked;
        print("____________xxx$isLiked");
      });
    }
  }
  @override
  void initState()  {
    super.initState();
    getVideo();
    _getMoreCommentVideo();
    _refreshController = RefreshController();
    videoBloc.resetListCommentVideos();

  }

  @override
  void dispose() {
    super.dispose();
    _comment.dispose();
    _searchValue.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: ExpansionTile(
                    title: Text(
                      detailsVideo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          detailsVideo.decription,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );



    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () async {
              if (isLike) {
                int temp =  await videoBloc.getLikeID(detailsVideo.id, User.fromJson(storage.getItem('user')).id);
                if(temp != -1){
                  bool check = false;
                  await deleteRepo.deleteLike(temp).then((value) => check = value);
                  if(check){
                    setState(() {
                      getVideo();
                    });
                  }
                }
              } else {
                await postRepo.postLike(new Like(
                    userId: User.fromJson(storage.getItem('user')).id,
                    videoId: detailsVideo.id,
                    status: true));
                setState(() {
                  getVideo();
                });
              }
            },
            child: _buildButtonColumn(isLike ? like : color, Icons.favorite,
                '${detailsVideo.likeCount}'),
          ),
          _buildButtonColumn(
              color, Icons.comment, '${detailsVideo.commentCount}'),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        iconTheme: IconThemeData(color: Colors.black87),
        title: !isSearching
            ? Text(
                'TikTube',
                style: TextStyle(color: Colors.blueGrey[800]),
              )
            : TextField(
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    setState(() {
                      this.isNull = false;
                    });
                  } else {
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
              ? isNull
                  ? IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        setState(() {
                          this.isSearching = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        videoBloc.resetListVideosSearch();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => generateListVideo(
                              searchValue: _searchValue.text,
                              pageSize: 3,
                              pageNum: 1,
                            ),
                          ),
                        );
                      },
                    )
              : IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: Column(
        children: [
          VideosPlayer(
            networkVideos: [
              new NetworkVideo(
                videoUrl: detailsVideo.urlShare,
                videoControl: new NetworkVideoControl(autoPlay: true),
              )
            ],
          ),
          titleSection,
          buttonSection,
          SizedBox(
            height: 5,
          ),
          StreamBuilder<List<Comment>>(
            stream: videoBloc.listCommentVideo,
            builder: (context, AsyncSnapshot<List<Comment>> snapshot) {
              if (snapshot.hasData) {
                return _buildGenresWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
        child: TextField(
          controller: _comment,
          decoration: InputDecoration(
            hintText: 'Write something to comment',
            suffixIcon: IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.black87,
              ),
              onPressed: () async{
                //post comment
                var status = await postRepo.postComment(new Comment(
                  userId: User.fromJson(storage.getItem('user')).id,
                  videoId: detailsVideo.id,
                  status: true,
                  conttent: _comment.text,
                ));
                if(status == 200){
                  getVideo();
                  return Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                        builder: (context) => detailMedia(
                          detailsVideo: detailsVideo,
                        ),
                      ),
                          (Route<dynamic> route) => route.isFirst);
                }else{

                }
                print(_comment.text);
                print("_____$status");
              },
            ),
          ),
        ),
      ),
    );
  }

  Future getFuture(String content) {
    return Future(() async {
      await await postRepo.postComment(new Comment(
        userId: 1,
        videoId: detailsVideo.id,
        status: true,
        conttent: content,
      ));
      return "Sent comment success";
    });
  }

  Future<void> showProgress(BuildContext context, String content) async {
    var result = await showDialog(
        context: context,
        child: FutureProgressDialog(getFuture(content),
            message: Text('Loading...')));
    showResultDialog(context, result);
  }

  void showResultDialog(BuildContext context, String result) {
    SweetAlert.show(context, title: result, style: SweetAlertStyle.success,
        onPress: (bool isConfirm) {
      if (isConfirm) {
        getVideo();
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
              builder: (context) => detailMedia(
                detailsVideo: detailsVideo,
              ),
            ),
                (Route<dynamic> route) => route.isFirst);
      }
      return false;
    });
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
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

  Widget _buildGenresWidget(List<Comment> data) {
    List<Comment> listComment = data;
    print("length: ${listComment.length}");
    if (listComment.length == 0) {
      return Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "list comment empty",
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
              shrinkWrap: true,
              itemCount: listComment.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image(
                      image: NetworkImage(listComment[index].user.avatarUrl),
                    ),
                    title: Text(listComment[index].user.fullname),
                    subtitle: Text(listComment[index].conttent),
                    isThreeLine: true,
                  ),
                );
              }),
        ),
      );
    }
  }
}
