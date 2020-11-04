import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/Login/LoginBloc.dart';
import 'package:flutter_app/Layout/HomePage/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPage createState() => _loginPage();
}

class _loginPage extends State<loginPage>
    with SingleTickerProviderStateMixin {
  int displayAmount = 500;
  double _scale;
  AnimationController _animation;

  @override
  void initState() {
    _animation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animation.value;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AvatarGlow(
              endRadius: 90,
              duration: Duration(seconds: 2),
              glowColor: Colors.red,
              repeat: true,
              repeatPauseDuration: Duration(seconds: 2),
              startDelay: Duration(seconds: 1),
              child: Material(
                elevation: 15,
                shape: CircleBorder(),
                child: Image.asset("logoApp.png"),
                // child: CircleAvatar(
                //   backgroundColor: Color.fromARGB(255, 18, 32, 50),
                //   child: Image.asset("logoApp.png",),
                //   radius: 70,
                // ),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Chào mừng bạn",
              style: GoogleFonts.merriweather(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              "tới TikTube",
              style: GoogleFonts.merriweather(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Colors.blueGrey,
              ),
            ),

            SizedBox(
              height: 230,
            ),
            _btnGoogleSignIn("logoGoogle.png", "Sign in with Google"),
            SizedBox(
              height: 30,
            ),
            Text(
              "Nơi lưu trữ & chia sẽ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black45,
              ),
            ),
            Text(
              "những khoảng khắc thú vị của bạn",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnGoogleSignIn(String url, String text) {
    return Container(
      width: 300,
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          SignInWithGG().then((result) {
            if (result != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return homePage();
                  },
                ),
              );
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Image(
                  image: AssetImage(url),
                  height: 35.0,
                  width: 35.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
