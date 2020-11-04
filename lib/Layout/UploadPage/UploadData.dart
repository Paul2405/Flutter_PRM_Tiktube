import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_app/Bloc/Upload/UploadBloc.dart';
import 'package:videos_player/model/control.model.dart';
import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/videos_player.dart';

class uploadData extends StatefulWidget {
  @override
  _uploadDataState createState() => _uploadDataState();
}

String urlMedia = "";

class _uploadDataState extends State<uploadData> {
  Set<String> urls = Set();
  List<File> _selectedFiles = [];
  List<StorageUploadTask> _tasks = [];
  List<Widget> uploadingFiles = [];
  List<Widget> uploadedFiles = [];

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Widget futureBuilderUpload(File file) {
      return FutureBuilder(
        future: uploadImages(file, _tasks),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget child =
              snapshot.data == null ? Text('Loading') : snapshot.data;
          return child;
        },
      );
    }

    Widget futureBuilderDownload(StorageUploadTask task) {
      return FutureBuilder(
        future: fetchImages(task),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget child =
              snapshot.data == null ? Text('Loading') : snapshot.data;
          return child;
        },
      );
    }

    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            ButtonTheme(
              minWidth: 200,
              height: 50,
              child: RaisedButton(
                color: Colors.green,
                child: Text(
                  "Upload",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  List<Widget> tempFiles = [];
                  FilePickerResult result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp4'],
                  );
                  if (result != null) {
                    setState(() {
                      _selectedFiles.clear();
                      _selectedFiles =
                          result.paths.map((path) => File(path)).toList();
                    });
                    for (File file in _selectedFiles) {
                      tempFiles.add(futureBuilderUpload(file));
                    }
                    setState(() {
                      uploadingFiles = tempFiles;
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.green)),
              ),
            ),
            Expanded(
                flex: 1,
                child: ListView(
                  shrinkWrap: true,
                  children: uploadingFiles,
                )),
            Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: uploadedFiles,
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text('Refresh'),
                        onPressed: () {
                          StorageUploadTask taskMedia;
                          List<Widget> tempTasks = [];
                          for (StorageUploadTask task in _tasks) {
                            tempTasks.add(futureBuilderDownload(task));
                            taskMedia = task;
                          }
                          setState(() {
                            uploadedFiles = tempTasks;
                            getLinkLocation(taskMedia)
                                .then((value) => urlMedia = value);
                            print(urlMedia);
                          });
                        },
                      ),
                    ),
                  ],
                )),
          ],
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add_to_photos),
        //   onPressed: () async {},
        // ),
      ),
    );
  }
}
