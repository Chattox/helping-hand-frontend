import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import './dashboardHelpee.dart';
import './dashboardVolunteer.dart';
import './shoppingListDetailed.dart';

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
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Welcome Back",
          style: GoogleFonts.londrinaShadow(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: 1.5),
              fontSize: 40.0),
        )),
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          height: 1000.0,
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.screen == "registration")
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Thank you for registering. Please log in.',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                  ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                  child: TextField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark),
                        fontSize: 20.0),
                    cursorColor: Colors.green,
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email,
                          color: Theme.of(context).primaryColor),
                      labelText: "Email address:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColorLight)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                  child: TextField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark),
                        fontSize: 20.0),
                    cursorColor: Colors.green,
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key,
                          color: Theme.of(context).primaryColor),
                      labelText: "Password:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ButtonTheme(
                    height: 60.0,
                    minWidth: 400.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 3.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          enteredEmailAddress = emailController.text;
                          enteredPassword = passwordController.text;
                        });
                        queryBuilder(enteredEmailAddress, enteredPassword)
                            .then((user) {
                          String userType = user["userType"];
                          setState(() {
                            returnedUserType = userType;
                          });
                          return user;
                        }).then((data) {
                          if (returnedUserType == "volunteer" &&
                              data["shoppingListId"].length == 0) {
                            return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VolunteerDashboard(userData: data)),
                            );
                          }
                          if (returnedUserType == "volunteer" &&
                              data["shoppingListId"].length != 0) {
                            return Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => shoppingListDetailed(
                                    shoppingListId: data["shoppingListId"][0]
                                        ["_id"],
                                    volunteerData: data,
                                    screen: "login"),
                              ),
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
                        style: GoogleFonts.pangolin(
                          textStyle:
                              TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).accentColor,
          elevation: 0.0,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Image.asset(
                "images/groceries/groceries.png",
                width: 80.0,
              ),
            ),
          ]),
        ));
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
