import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/VideoBloc/VideoBloc.dart';
import 'package:flutter_app/Layout/HomePage/Generate_List_Video.dart';
import 'package:flutter_app/Model/Video/Video.dart';

class searchPage extends StatefulWidget {
  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  List<Video> listVideoSearch = [];
  TextEditingController searchValue = new TextEditingController();
  List<Widget> searchValueWidget = [];

  @override
  void dispose() {
    super.dispose();
    searchValue.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: searchValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87)),
              hintText: 'input to search...',
              labelText: 'Search',
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black87,
                ),
                onPressed: (){
                  print(searchValue.text);
                  videoBloc.searchVideoByTitle(searchValue.text, 3, 1);
                  // setState(() {
                  //   searchValueWidget =
                  // });
                },
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView(
            shrinkWrap: true,
            children: searchValueWidget,
          ),
        )
      ],
    );
  }
}
