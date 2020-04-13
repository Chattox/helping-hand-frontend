// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageCapture extends StatefulWidget {
//   ImageCapture({Key key}) : super(key: key);

//   @override
//   _ImageCaptureState createState() => _ImageCaptureState();
// }

// class _ImageCaptureState extends State<ImageCapture> {
// //active image file
//   File _imageFile;

// //select an image via gallery or camera
//   Future<void> _pickImage(ImageSource source) async {
//     File selected = await ImagePicker.pickImage(source: source);
//     setState(() {
//       _imageFile = selected;
//     });
//   }

//   //remove image
//   void _clear() {
//     setState(() {
//       _imageFile = null;
//     });
//   }

//   Future<void> _cropImage() async {
//     File cropped = await ImageCropper.cropImage(
//       // AndroidUiSettings(
//       //     activeWidgetColor: Colors.green[400],
//       //     toolbarColor: Theme.of(context).primaryColor,
//       //     toolbarTitle: "Crop your image"),
//       sourcePath: _imageFile.path,
//     );

//     setState(() {
//       _imageFile = cropped ?? _imageFile;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           children: <Widget>[
//             IconButton(
//                 icon: Icon(Icons.photo_camera),
//                 onPressed: () => _pickImage(ImageSource.camera)),
//             IconButton(
//                 icon: Icon(Icons.photo_library),
//                 onPressed: () => _pickImage(ImageSource.gallery))
//           ],
//         ),
//       ),
//       body: ListView(
//         children: <Widget>[
//           if (_imageFile != null) ...[
//             Image.file(_imageFile),
//             Row(
//               children: <Widget>[
//                 FlatButton(
//                   child: Icon(Icons.crop),
//                   onPressed: _cropImage,
//                 ),
//                 FlatButton(
//                   child: Icon(Icons.refresh),
//                   onPressed: _clear,
//                 )
//               ],
//             ),
//             Uploader(file: _imageFile)
//           ]
//         ],
//       ),
//     );
//   }
// }

// class Uploader extends StatefulWidget {
//   final File file;

//   Uploader({Key key, this.file}) : super(key: key);

//   @override
//   _UploaderState createState() => _UploaderState();
// }

// class _UploaderState extends State<Uploader> {
//   final FirebaseStorage _storage =
//       FirebaseStorage(storageBucket: 'gs://helping-hand-kjc.appspot.com/');

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
