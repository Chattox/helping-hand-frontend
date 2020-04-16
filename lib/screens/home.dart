import 'dart:core';
import 'package:flutter/material.dart';
import './login.dart';
import './registration.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  final String login;
  MyHomePage({Key key, @required this.title, this.login}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: 1000.0,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 100.0, left: 20.0),
              child: Center(
                child: ShoppingBasketLogo(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Helping",
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    " Hand",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: "LondrinaShadow"),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 400.0,
                    child: Button(text: "Login", pageName: "Login"),
                  ),
                  ButtonTheme(
                    minWidth: 400.0,
                    child: Button(
                        text: "I would like to help.",
                        pageName: "Registration"),
                  ),
                  ButtonTheme(
                    minWidth: 400.0,
                    child: Button(
                        text: "Can you do my shopping?",
                        pageName: "Registration"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShoppingBasketLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage shoppingBasketAsset = AssetImage('images/shopping-list.png');
    Image image = Image(
      image: shoppingBasketAsset,
      height: 200.0,
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
      height: 70.0,
      margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
      padding: EdgeInsets.all(3.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18.0),
        ),
        textColor: Theme.of(context).primaryColor,
        color: Colors.white,
        hoverColor: Colors.white60,
        onPressed: () {
          switch (text) {
            case 'Login':
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(screen: ""),
                ),
              );
              break;
            case 'Register as a Volunteer':
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registration(screen: "volunteer"),
                ),
              );
              break;
            case "I'm in need of help":
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registration(screen: "helpee"),
                ),
              );
              break;
          }
        },
      ),
    );
    return button;
  }
}
