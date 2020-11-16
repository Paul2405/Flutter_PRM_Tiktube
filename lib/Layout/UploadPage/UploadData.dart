import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_app/Bloc/Upload/UploadBloc.dart';
import 'package:flutter_app/Layout/HomePage/HomePage.dart';
import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:flutter_app/Model/Video/Video.dart';
import 'package:flutter_app/Repository/RepositoryPost.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sweetalert/sweetalert.dart';

class uploadData extends StatefulWidget {
  @override
  _uploadDataState createState() => _uploadDataState();
}

class _uploadDataState extends State<uploadData> {
  Set<String> urls = Set();
  File _selectedFiles;
  List<StorageUploadTask> _tasks = [];
  List<Widget> uploadingFiles = [];
  List<Widget> uploadedFiles = [];
  String fileName = "";

  TextEditingController _title = new TextEditingController();
  TextEditingController _decription = new TextEditingController();
  final LocalStorage _storage = LocalStorage('user');

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Upload your video".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _title,
              maxLines: 1,
              maxLength: 250,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
                hintText: 'Input title for your video',
                labelText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _decription,
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
                hintText: 'Input decription for your video',
                labelText: 'Decription',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  "Attach your file: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 65),
                    child: IconButton(
                        icon: Icon(
                          Icons.cloud_upload,
                          size: 30,
                        ),
                        onPressed: () async {
                          List<Widget> tempFiles = [];
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['mp4'],
                            allowMultiple: false,
                          );
                          if (result != null) {
                            setState(() {
                              _selectedFiles = File(result.files.single.path);
                              fileName = _selectedFiles.path.split("/").last;
                            });
                            tempFiles.add(futureBuilderUpload(_selectedFiles));
                            setState(() {
                              uploadingFiles = tempFiles;
                            });
                          }
                        })),
              ],
            ),
          ),
          Text(fileName),
          Expanded(
              flex: 1,
              child: ListView(
                shrinkWrap: true,
                children: uploadingFiles,
              )),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ButtonTheme(
              minWidth: 200,
              height: 50,
              child: RaisedButton(
                color: Colors.green,
                child: Text(
                  "Upload",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async{
                  StorageUploadTask taskMedia;
                  List<Widget> tempTasks = [];
                  String url;
                  for (StorageUploadTask task in _tasks) {
                    tempTasks.add(futureBuilderDownload(task));
                    taskMedia = task;
                  }
                  if (taskMedia.isComplete) {
                     await getLinkLocation(taskMedia).then((value) => url = value);
                    showProgress(context, url);
                  }
                  setState(() {
                    uploadedFiles = tempTasks;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.green)),
              ),
            ),
          ),
        ],
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add_to_photos),
        //   onPressed: () async {},
        // ),
      ),
    );
  }

  Future getFuture(String url) {
    return Future(() async {
      await await postRepo.postVideo(new Video(
        id: 0,
        title: _title.text,
        decription: _decription.text,
        userId: User.fromJson(_storage.getItem("user")).id,
        urlShare: url,
        likeCount: 0,
        commentCount: 0,
        status: true
      ));
      return "Upload video success";
    });
  }

  Future<void> showProgress(BuildContext context, String url) async {
    var result = await showDialog(
        context: context,
        child: FutureProgressDialog(getFuture(url),
            message: Text('Loading...')));
    showResultDialog(context, result);
  }

  void showResultDialog(BuildContext context, String result) {
    SweetAlert.show(context, title: result, style: SweetAlertStyle.success,
        onPress: (bool isConfirm) {
      if (isConfirm) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => new homePage()),
        );
      }
      return false;
    });
  }
}
