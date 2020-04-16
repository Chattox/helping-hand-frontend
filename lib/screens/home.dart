import 'dart:core';
import 'package:flutter/material.dart';
import './login.dart';
import './registration.dart';
import 'package:google_fonts/google_fonts.dart';

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
              padding: EdgeInsets.only(top: 60.0, left: 20.0),
              child: Center(
                child: ShoppingBasketLogo(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Helping",
                    style: GoogleFonts.londrinaSolid(
                      textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: 60.0),
                    ),
                  ),
                  Text(
                    "Hand",
                    style: GoogleFonts.londrinaShadow(
                      textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: 60.0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
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
                        text: "Help me with my shopping",
                        pageName: "Registration"),
                  ),
                  ButtonTheme(
                    minWidth: 400.0,
                    child: Button(
                        text: "I'm here to help", pageName: "Registration"),
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
      height: 80.0,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.all(3.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
        ),
        child: Text(
          text,
          style: GoogleFonts.pangolin(
            textStyle: TextStyle(fontSize: 25.0),
          ),
        ),
        textColor: Theme.of(context).primaryColorDark,
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
            case "I'm here to help":
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registration(screen: "volunteer"),
                ),
              );
              break;
            case "Help me with my shopping":
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
