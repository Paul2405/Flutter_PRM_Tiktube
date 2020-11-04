import 'package:flutter/material.dart';
import 'package:flutter_app/Layout/Detail/Detail_media.dart';

class homeWidget extends StatefulWidget {
  @override
  _homeWidgetState createState() => _homeWidgetState();
}

class _homeWidgetState extends State<homeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: 10,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => detailMedia()))
                    },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            child: Image.asset("logoApp.jpg",
                                // width: 300,
                                height: 200,
                                fit: BoxFit.fill),
                          ),
                          ListTile(
                            title: Text('Title'),
                            subtitle: Text('Decription'),
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
