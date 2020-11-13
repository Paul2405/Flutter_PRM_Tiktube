
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/Login/LoginBloc.dart';
import 'package:flutter_app/Layout/LoginLogout/LoginPage.dart';
import 'package:flutter_app/Layout/LoginLogout/Logout.dart';
import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localstorage/localstorage.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfile createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  final LocalStorage storage = LocalStorage('user');


  @override
  void initState() {
    super.initState();
  }

  static const double _imageHeight = 256.0;
  TextEditingController _fullname ;
  TextEditingController _phone ;
  TextEditingController _birthday ;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: storage.ready,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              var user = User.fromJson(storage.getItem('user'));
              _fullname = new TextEditingController(text: user.fullname);
              _phone = new TextEditingController(text: user.phone);
              _birthday = new TextEditingController(text: user.birthday);
              List<String> ListRowIfo = [
                checkNull(user.fullname),
                checkNull(user.phone),
                checkNull(user.birthday),
                checkNull(Jiffy(user.creationDate).yMMMMd)
              ];
              List<String> ListRowTitle = [
                "Fullname",
                "Phone",
                "Birthday",
                "Creation day",
              ];
              return Container(
                child: Stack(
                  children: <Widget>[
                    _buildTimeline(),
                    _buildImage(),
                    _buildProfileRow(
                        checkNull(user.fullname), checkNull(user.email),
                        checkNull(user.avatarUrl)),
                    _buildBottomPart(ListRowIfo, ListRowTitle),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          }),
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
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.blueAccent),
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

  Widget _buildImage() =>
      ClipPath(
        clipper: DialogonalClipper(),
        child: Container(
          width: double.infinity,
          child: Image.network(
            'https://previews.123rf.com/images/9dreamstudio/9dreamstudio1902/9dreamstudio190201024/116569143-movie-premiere-concept-clapperboard-and-popcorn-on-yellow-background-top-view-.jpg',
            fit: BoxFit.cover,
            height: _imageHeight,
            colorBlendMode: BlendMode.srcOver,
            color: Color.fromARGB(80, 20, 10, 40),
          ),
        ),
      );

  Widget _buildProfileRow(String userName, String email, String imgSrc) =>
      Padding(
        padding: const EdgeInsets.only(top: _imageHeight / 2.5, left: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              minRadius: 28.0,
              maxRadius: 28.0,
              backgroundImage: NetworkImage(imgSrc),
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      userName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        email,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _buildBottomPart(List<String> userInfo, List<String> title) =>
      Padding(
        padding: const EdgeInsets.only(top: _imageHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildMyTaskHeader(),
            _buildTaskList(userInfo, title),
            Center(child: CusLogoutBtn()),
          ],
        ),
      );

  Widget _buildTaskList(List<String> userInfo, List<String> title) =>
      Expanded(
          child: AnimatedList(
              initialItemCount: 4,
              itemBuilder: (context, index, animation) =>
                  TaskRow(
                    title: title[index],
                    userInfo: userInfo[index],
                    animation: animation,
                  )));

  Widget _buildMyTaskHeader() =>
      Padding(
        padding: const EdgeInsets.only(left: 64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: IconButton(
                    icon: Icon(Icons.edit, size: 15,),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Edit profile"),
                              content: Container(
                                height: 200,
                                child: Column(
                                  children: [
                                     TextField(
                                       controller: _fullname,
                                       decoration: InputDecoration(
                                         labelText: "fullname"
                                       ),
                                     ),
                                    TextField(
                                      controller: _phone,
                                      decoration: InputDecoration(
                                          labelText: "phone"
                                      ),
                                    ),
                                    TextField(
                                      controller: _birthday,
                                      decoration: InputDecoration(
                                          labelText: "birthday"
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(onPressed: (){Navigator.pop(context, false);}, child: Text("Cancel".toUpperCase())),
                                TextButton(onPressed: (){}, child: Text("Update".toUpperCase()))
                              ],
                            );
                          });
                    },
                  ),
                ),

              ],
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      );

  Widget _buildTimeline() =>
      Positioned(
        top: 0.0,
        bottom: 0.0,
        left: 32.0,
        child: Container(
          width: 1.0,
          color: Colors.grey[300],
        ),
      );
}

class TaskRow extends StatelessWidget {
  final String userInfo;
  final String title;
  final Animation<double> animation;

  const TaskRow({Key key, this.animation, this.userInfo, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.5),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.orange),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      checkNull(userInfo),
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) =>
      Path()
        ..lineTo(0.0, size.height - 60.0)..lineTo(
          size.width, size.height)..lineTo(size.width, 0.0)
        ..close();

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

String checkNull(String temp) {
  if (temp == null) {
    return "";
  }
  return temp;
}
