import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Layout/Detail/Detail_media.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'package:videos_player/model/control.model.dart';
import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/videos_player.dart';

class generateListVideos extends StatefulWidget {
  final List<Video> listVideo;

  const generateListVideos({Key key, this.listVideo}) : super(key: key);

  @override
  _generateListVideosState createState() => _generateListVideosState(listVideo);
}

class _generateListVideosState extends State<generateListVideos> {
  final List<Video> listVideo;

  _generateListVideosState(this.listVideo);

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
                                builder: (context) => detailMedia(detailsVideo: listVideo[index],)))
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
                                  videoControl:
                                      new NetworkVideoControl(autoPlay: false),
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
    );
  }
}
