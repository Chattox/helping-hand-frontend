import 'dart:core';
import 'package:flutter/material.dart';
import './imageCapture.dart';

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
    print(widget.userData);
    if (widget.userData["shoppingListId"].length == 0) {
      return ImageCapture(userId: widget.userData["_id"]);
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Dashboard")),
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("My Current Shopping Order"),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("placeholder for photo of current shopping list"),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                //send mutation to update shoppinglist status <<<<<<
              },
              child: Text(
                "Order Received",
                textScaleFactor: 1.2,
              ),
            )
          ]),
        ),
      );
    }
  }
}
