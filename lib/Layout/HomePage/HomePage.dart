import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Layout/HomePage/Widget_Home.dart';
import 'package:flutter_app/Layout/UploadPage/UploadData.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final uploadData _uploadData =  new uploadData();
  final homeWidget _home =  new homeWidget();
  //final Profile _profile =  new Profile();

  Widget _showContent = new homeWidget();

  Widget choiceWidgetToshow(int index){
    switch(index){
      case 0:{
        return _home;
        break;
      }
      case 1:{
        return _uploadData;
        break;
      }
      // case 3:{
      //   return _proFile
      //   break;
      // }
      default:break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(
            "logoApp.png",
            height: 100,
            width: 100,
          ),
        ),
        title: Text(
          "TikTube",
          style: TextStyle(color: Colors.blueGrey[800]),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.search,
              color: Colors.blueGrey[800],
            ),
          ),
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
