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
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        width: 1000.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: DecorationImage(
              repeat: ImageRepeat.noRepeat,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage('./images/grocery-cart-with-item.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 180.0),
              child: Center(
                child: Icon(
                  Icons.shopping_basket,
                  color: Colors.white,
                  size: 65.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Helping",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " Hand",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 100.0),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Button(text: "Login", pageName: "Login"),
                  Button(
                      text: "Register as a Volunteer",
                      pageName: "Registration"),
                  Button(text: "I'm in need of help", pageName: "Registration"),
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
      height: 50.0,
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
