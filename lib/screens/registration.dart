import 'dart:core';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  final String screen;

  Registration({Key key, @required this.screen}) : super(key: key);
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // final String screen;

  // if (screen == "volunteer") {}
  // ;

  @override
  Widget build(BuildContext context) {
    if (widget.screen == "volunteer") {
      print("hello");
    }
    return Container();
  }
}

// class Registration extends StatefulWidget {
//   @override
//   _RegistrationState createState() => _RegistrationState();
// }

// class _RegistrationState extends State<Registration> {

//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Text("Registration Page"));
//   }
// }
