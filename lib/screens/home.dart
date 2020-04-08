import 'dart:core';
import 'package:flutter/material.dart';
import './login.dart';
import './registration.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  String login;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
          child: Column(
        children: <Widget>[
          ShoppingBasketLogo(),
          Button(text: "Login", pageName: "Login"),
          Button(text: "Register as a Volunteer", pageName: "Registration"),
          Button(text: "Im in need of help", pageName: "Registration")
        ],
      )),
    );
  }
}

class ShoppingBasketLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage shoppingBasketAsset = AssetImage('images/shopping-cart.png');
    Image image = Image(
      image: shoppingBasketAsset,
      width: 250.0,
      height: 250.0,
    );
    return Container(child: image);
  }
}

class Button extends StatelessWidget {
  final String text;
  final String pageName;
  const Button({Key key, @required this.text, @required this.pageName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var button = Container(
      margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
      child: RaisedButton(
        child: Text(text),
        color: Colors.white,
        elevation: 5.0,
        onPressed: () {
          switch (text) {
            case 'Login':
              return Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
              break;
            case 'Register as a Volunteer':
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Registration()));
              break;
            case 'Im in need of help':
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Registration()));
              break;
          }
        },
      ),
    );
    return button;
  }
}
