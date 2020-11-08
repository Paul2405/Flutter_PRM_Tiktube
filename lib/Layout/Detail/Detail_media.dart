import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Model/Video/Video.dart';
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
  final Video detailsVideo;

  _detailMediaState(this.detailsVideo);

  TextEditingController _comment = new TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _comment.dispose();
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

    Color color = Colors.black87;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.favorite, '${detailsVideo.likeCount}'),
          _buildButtonColumn(color, Icons.comment, '${detailsVideo.commentCount}'),
          _buildButtonColumn(color, Icons.share, 'Share'),
        ],
      ),
    );

    Widget comment = Container(
      color: Colors.pink[50],
      height: 600,
      width: 200,
      child: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext contex, int index) {
            return Card(
              child: ListTile(
                leading: Image(
                  image: AssetImage("logoApp.png"),
                ),
                title: Text('Name user'),
                subtitle: Text(
                    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
                isThreeLine: true,
              ),
            );
          }),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TikTube',
          style: TextStyle(color: Colors.blueGrey[800]),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.pink[50],
      ),
      body: ListView(
        children: [
          VideosPlayer(
            networkVideos: [
              new NetworkVideo(
                videoUrl:
                    detailsVideo.urlShare,
                videoControl: new NetworkVideoControl(autoPlay: true),
              )
            ],
          ),
          titleSection,
          buttonSection,
          SizedBox(height: 5,),
          comment,
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
        child: TextField(
          controller: _comment,
          decoration: InputDecoration(
              hintText: 'Write something to comment',
              suffixIcon: Icon(
                Icons.send, color: Colors.black87,
              )
          ),
        ),
      ),
    );
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
}
