import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import './dashboardHelpee.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageCapture extends StatefulWidget {
  final String userId;
  ImageCapture({Key key, @required this.userId}) : super(key: key);

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
      appBar: AppBar(
        title: Text("Your Shopping List",
            style: GoogleFonts.londrinaShadow(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 1.5),
                fontSize: 40.0)),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).accentColor,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).accentColor,
        elevation: 0.0,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: Image.asset(
              "images/groceries/shopping-list-basket.png",
              width: 80.0,
            ),
          ),
        ]),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (_imageFile == null) ...[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ButtonTheme(
                    height: 60.0,
                    minWidth: 400.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 3.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                          ),
                          Icon(Icons.photo_camera,
                              size: 80.0, color: Colors.white),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
                            child: Text(
                              "Take a photo of your shopping list",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.pangolin(
                                textStyle: TextStyle(
                                    fontSize: 28.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ButtonTheme(
                    height: 60.0,
                    minWidth: 400.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 3.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                            child: Icon(Icons.photo_library,
                                size: 80.0, color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
                            child: Text(
                              "Choose from your \nphoto gallery",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.pangolin(
                                textStyle: TextStyle(
                                    fontSize: 28.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ),
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
                Uploader(file: _imageFile, userId: widget.userId)
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final String userId;
  Uploader({Key key, this.file, this.userId}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://helping-hand-kjc.appspot.com/');

  StorageUploadTask _uploadTask;

  _startUpload() async {
    String filePath =
        'images/${widget.userId}.png'; // <<< file name needs changing if we want multiple files per user

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    var downUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();

    queryBuilder(widget.userId, url);
    return url;
  }

  Future queryBuilder(userId, url) async {
    String shoppingListQuery = '''mutation shoppingListQuery {
  createShoppingList(shoppingListInput: {helpee: "$userId", listImage: "$url"}) {listImage
  }
}''';
    final HttpLink httpLink = HttpLink(
      uri: 'http://helping-hand-kjc.herokuapp.com/graphql',
    );
    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
    final response = await client
        .mutate(MutationOptions(documentNode: gql(shoppingListQuery)));
    Map<String, dynamic> imageUrl = response.data;
    return imageUrl;
  }

  Future userDataBuilder(userId) async {
    String userQuery = '''query userQuery {
   userById(id: "$userId") {
    _id
    name
    email
    phoneNumber
    postcode
    streetAddress
    city
    distanceToTravel
    profilePhoto
    shoppingListId {
      _id
      }
  }
  }''';
    final HttpLink httpLink = HttpLink(
      uri: 'http://helping-hand-kjc.herokuapp.com/graphql',
    );
    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
    final response =
        await client.query(QueryOptions(documentNode: gql(userQuery)));
    Map user = response.data["userById"];
    return user;
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
                if (_uploadTask.isInProgress)
                  Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        backgroundColor: Colors.green,
                      )),
                if (_uploadTask.isInProgress)
                  Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child:
                          Text("${(progressPercent * 100).ceil()}% complete")),
                if (_uploadTask.isComplete)
                  Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text("Shopping list has been uploaded")),
                if (_uploadTask.isComplete)
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    width: 280.0,
                    child: FlatButton.icon(
                      color: Theme.of(context).primaryColor,
                      label: Text("See My Shopping List"),
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        userDataBuilder(widget.userId).then((data) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HelpeeDashboard(userData: data)));
                        });
                      },
                    ),
                  ),
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
