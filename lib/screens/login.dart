import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './dashboardHelpee.dart';
import './dashboardVolunteer.dart';

class Login extends StatefulWidget {
  final String screen;

  Login({Key key, @required this.screen}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static String enteredEmailAddress = "";
  static String enteredPassword = "";
  String returnedUserType = "";
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            if (widget.screen == "registration")
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text('Successful registration. Please log in.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email address:",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password:",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                setState(() {
                  enteredEmailAddress = emailController.text;
                  enteredPassword = passwordController.text;
                });
                queryBuilder(enteredEmailAddress, enteredPassword).then((user) {
                  String userType = user["userType"];
                  setState(() {
                    returnedUserType = userType;
                  });
                  return user;
                }).then((data) {
                  if (returnedUserType == "volunteer") {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VolunteerDashboard(userData: data)),
                    );
                  }
                  if (returnedUserType == "helpee") {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HelpeeDashboard(userData: data)),
                    );
                  }
                  return null;
                });
              },
              child: Text(
                "Login",
                textScaleFactor: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future queryBuilder(email, password) async {
    String loginQuery = '''query loginQuery {
  login(email: "$email", password: "$password") {
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
    userType
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
        await client.query(QueryOptions(documentNode: gql(loginQuery)));
    Map user = response.data["login"];
    return user;
  }

  void reset() {
    emailController.text = "";
    passwordController.text = "";
    setState(() {
      enteredEmailAddress = "";
      enteredPassword = "";
    });
  }
}
