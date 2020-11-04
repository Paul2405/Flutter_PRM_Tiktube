import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/Layout/HomePage/HomePage.dart';
import 'package:flutter_app/Layout/LoginPage/LoginPage.dart';
import 'package:flutter_app/Layout/UploadPage/UploadData.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: loginPage(),
    );
  }
}

