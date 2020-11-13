import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/Login/LoginBloc.dart';

import 'LoginPage.dart';

class CusLogoutBtn extends StatefulWidget {
  @override
  _CusLogoutBtnState createState() => _CusLogoutBtnState();
}

class _CusLogoutBtnState extends State<CusLogoutBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: ButtonTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: RaisedButton(
          color: Colors.redAccent,
          onPressed: () {
            SignOutGG();
            Route route =
            MaterialPageRoute(builder: (context) => loginPage());
            Navigator.push(context, route);
          },
          child: Text(
            "Logout".toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
