import 'dart:core';
import 'package:flutter/material.dart';

class HelpeeDashboard extends StatefulWidget {
  final Map userData;
  HelpeeDashboard({Key key, @required this.userData}) : super(key: key);
  @override
  _HelpeeDashboardState createState() => _HelpeeDashboardState();
}

class _HelpeeDashboardState extends State<HelpeeDashboard> {
  @override
  Widget build(BuildContext context) {
    print(widget.userData["name"]);
    return Text("Helpee");
  }
}
