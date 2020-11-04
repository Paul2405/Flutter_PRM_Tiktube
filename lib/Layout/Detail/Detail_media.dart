import 'package:flutter/material.dart';
import 'package:videos_player/model/control.model.dart';
import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/videos_player.dart';

// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

class detailMedia extends StatefulWidget {
  @override
  _detailMediaState createState() => _detailMediaState();
}

class _detailMediaState extends State<detailMedia> {
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
                      'Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Text(
                        'Decription',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
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
          _buildButtonColumn(color, Icons.favorite, 'Like'),
          _buildButtonColumn(color, Icons.comment, 'Comment'),
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
          'Flutter layout demo',
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
                    "https://firebasestorage.googleapis.com/v0/b/tiktube-5bfbf.appspot.com/o/U001%2FVID_20201017_161340(0).mp4?alt=media&token=3a76fa93-ac99-4f22-9236-6dca8d671809",
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
