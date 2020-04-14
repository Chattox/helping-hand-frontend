import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  ImageCapture({Key key}) : super(key: key);

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
//active image file
  File _imageFile;

//select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }

  //remove image
  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      // AndroidUiSettings(
      //     activeWidgetColor: Colors.green[400],
      //     toolbarColor: Theme.of(context).primaryColor,
      //     toolbarTitle: "Crop your image"),
      sourcePath: _imageFile.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Your Shopping List")),
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_imageFile == null) ...[
              Container(
                alignment: Alignment(0.0, 0.0),
                margin: new EdgeInsets.all(20.0),
                width: 320.0,
                color: Colors.green[200],
                child: FlatButton(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.photo_camera, size: 80.0),
                      Text(
                        " Take A Photo Of Your Shopping List",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                  padding: EdgeInsets.all(10.0),
                ),
              ),
              Container(
                  width: 320.0,
                  color: Theme.of(context).primaryColor,
                  child: FlatButton(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.photo_library, size: 80.0),
                        Text(" Choose From Your Photo Gallery",
                            style: TextStyle(fontSize: 16.0))
                      ],
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    padding: EdgeInsets.all(10.0),
                  )),
            ],
            if (_imageFile != null) ...[
              Image.file(
                _imageFile,
                alignment: Alignment.center,
                height: 400.0,
                fit: BoxFit.scaleDown,
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 280.0,
                    child: FlatButton.icon(
                      color: Theme.of(context).primaryColor,
                      label: Text("Crop"),
                      icon: Icon(Icons.crop),
                      onPressed: _cropImage,
                    ),
                  )
                ],
              ),
              Uploader(file: _imageFile)
            ]
          ],
        ),
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://helping-hand-kjc.appspot.com/');

  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: <Widget>[
                if (_uploadTask.isComplete)
                  Text("Shopping list has been uploaded"),
                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),
                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),
                LinearProgressIndicator(value: progressPercent)
              ],
            );
          });
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              width: 280.0,
              child: FlatButton.icon(
                color: Theme.of(context).primaryColor,
                label: Text('Upload image'),
                icon: Icon(Icons.cloud_upload),
                onPressed: _startUpload,
              ),
            ),
            Container(
              width: 280.0,
              child: FlatButton.icon(
                color: Theme.of(context).primaryColor,
                label: Text("Back"),
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      );
    }
  }
}
