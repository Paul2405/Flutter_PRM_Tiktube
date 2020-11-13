import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/VideoBloc/VideoBloc.dart';
import 'package:flutter_app/Layout/HomePage/Generate_List_Video.dart';
import 'package:flutter_app/Layout/HomePage/Widget_Home.dart';
import 'package:flutter_app/Layout/Profile/User_Profile.dart';
import 'package:flutter_app/Layout/UploadPage/UploadData.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  static int _pageSize = 3;
  static int _pageNum = 1;
  bool isSearching = false;
  bool isNull = true;
  TextEditingController _searchValue = new TextEditingController();

  final uploadData _uploadData = new uploadData();
  final homeWidget _home = new homeWidget(
    pageSize: _pageSize,
    pageNum: _pageNum,
  );
  final UserProfile _profile = new UserProfile();

  Widget _showContent = new homeWidget(
    pageSize: _pageSize,
    pageNum: _pageNum,
  );

  Widget choiceWidgetToshow(int index) {
    switch (index) {
      case 0:
        {
          videoBloc.resetListVideos();
          return _home;
          break;
        }
      case 1:
        {
          return _uploadData;
          break;
        }
      // case 2:{
      //   return _search;
      //   break;
      // }
      case 2:
        {
          return _profile;
          break;
        }
      default:
        break;
    }
  }

  @override
  void dispose() {
    _searchValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("logoApp.png"),
        backgroundColor: Colors.pink[50],
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
      body: Container(
        child: _showContent,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        color: Colors.pink[50],
        height: 50,
        backgroundColor: Colors.white,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _showContent = choiceWidgetToshow(index);
          });
        },
      ),
    );
  }
}
