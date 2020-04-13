import 'dart:core';
import 'package:flutter/material.dart';

class VolunteerDashboard extends StatefulWidget {
  final Map userData;
  VolunteerDashboard({Key key, @required this.userData}) : super(key: key);
  @override
  _VolunteerDashboardState createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  @override
  Widget build(BuildContext context) {
    print(widget.userData["name"]);
    return Text("Volunteer");
  }
}
