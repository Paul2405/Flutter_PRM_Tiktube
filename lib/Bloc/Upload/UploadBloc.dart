
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Layout/UploadPage/UploadProcess.dart';

final StorageReference ref = FirebaseStorage.instance.ref();

Future<Widget> fetchImages(StorageUploadTask task) async {
  String url = await task.lastSnapshot.ref.getDownloadURL();
  return Padding(padding: EdgeInsets.all(8.0), child: Text('$url'));
}
Future<String> getLinkLocation(StorageUploadTask task) async {
  String url = await task.lastSnapshot.ref.getDownloadURL();
  return url;
}

Future<Widget> uploadImages(File file, List<StorageUploadTask> _tasks) async {
  String name;
  name = file.path.split('/').last;
  StorageUploadTask task = ref.child('U001/$name').putFile(file);
  _tasks.add(task);
  return UploadTile(
    file: file,
    task: task,
  );
}
