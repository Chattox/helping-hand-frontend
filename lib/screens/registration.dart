import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import './login.dart';

class Registration extends StatefulWidget {
  final String screen;

  Registration({Key key, @required this.screen}) : super(key: key);
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String enteredName = '';
  String enteredEmail = '';
  String enteredPassword = '';
  int enteredPhoneNumber = 0;
  String enteredPostcode = '';
  String enteredStreetAddress = '';
  String enteredCity = "";
  double enteredDistanceToTravel = 5.0;
  bool checkboxValue = false;

  bool isButtonDisabled = false;

  @override
  void initState() {
    isButtonDisabled = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Registration",
          style: GoogleFonts.londrinaShadow(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: 1.5),
              fontSize: 40.0),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: (Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "images/groceries/fruit.png",
                        width: 50.0,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 7.0, right: 15.0),
                  child: TextFormField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark),
                        fontSize: 20.0),
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      icon: Icon(Icons.person,
                          color: Theme.of(context).primaryColor),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                  child: TextFormField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark),
                        fontSize: 20.0),
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      icon: Icon(Icons.alternate_email,
                          color: Theme.of(context).primaryColor),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                  child: TextFormField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark),
                        fontSize: 20.0),
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.vpn_key,
                          color: Theme.of(context).primaryColor),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                  child: TextFormField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark),
                        fontSize: 20.0),
                    controller: password2Controller,
                    decoration: InputDecoration(
                      labelText: 'Re-Type Password',
                      icon: Icon(Icons.vpn_key,
                          color: Theme.of(context).primaryColor),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                  child: TextFormField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark),
                        fontSize: 20.0),
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Telephone Number',
                      icon: Icon(Icons.call,
                          color: Theme.of(context).primaryColor),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your telephone number';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                  child: TextFormField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColorDark),
                        fontSize: 20.0),
                    controller: postcodeController,
                    decoration: InputDecoration(
                      labelText: 'Postcode',
                      icon: Icon(Icons.location_on,
                          color: Theme.of(context).primaryColor),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your postcode';
                      }
                      return null;
                    },
                  ),
                ),
                if (widget.screen == 'helpee')
                  Padding(
                    padding:
                        EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                    child: TextFormField(
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColorDark),
                          fontSize: 20.0),
                      controller: streetAddressController,
                      decoration: InputDecoration(
                        labelText: 'Street Address',
                        icon: Icon(Icons.location_on,
                            color: Theme.of(context).primaryColor),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your street address';
                        }
                        return null;
                      },
                    ),
                  ),
                if (widget.screen == 'helpee')
                  Padding(
                    padding:
                        EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                    child: TextFormField(
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColorDark),
                          fontSize: 20.0),
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        icon: Icon(Icons.location_on,
                            color: Theme.of(context).primaryColor),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                  ),
                if (widget.screen == 'volunteer')
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "0",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor),
                              fontSize: 30.0),
                        ),
                        Expanded(
                          child: Slider(
                            value: enteredDistanceToTravel,
                            min: 0,
                            max: 10,
                            divisions: 20,
                            label: "$enteredDistanceToTravel",
                            activeColor: Theme.of(context).primaryColorDark,
                            onChanged: (value) {
                              setState(() {
                                enteredDistanceToTravel = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          "10",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor),
                              fontSize: 30.0),
                        ),
                      ],
                    ),
                  ),
                if (widget.screen == 'volunteer')
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      "Distance willing to travel: $enteredDistanceToTravel miles",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColorDark),
                          fontSize: 20.0),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                  child: CheckboxListTile(
                    title: widget.screen == 'volunteer'
                        ? Text(
                            "Disclaimer: I confirm that I authorise my name and phone number to be shared with the person I am helping.",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColorDark),
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.justify)
                        : Text(
                            "Disclaimer: I confirm that I authorise my name and approximate location to be shared with all potential volunteers in my area and also my phone number and exact address to be shared with the person who helps me.",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColorDark),
                              fontSize: 15.5,
                            ),
                            textAlign: TextAlign.justify),
                    value: checkboxValue,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      setState(() {
                        checkboxValue = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
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
                      child: isButtonDisabled
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    "images/loader.gif",
                                    width: 30.0,
                                  ),
                                  Text(
                                    "Processing...",
                                    style: GoogleFonts.pangolin(
                                      textStyle: TextStyle(
                                          fontSize: 25.0, color: Colors.white),
                                    ),
                                  )
                                ])
                          : Text(
                              "Register",
                              style: GoogleFonts.pangolin(
                                textStyle: TextStyle(
                                    fontSize: 25.0, color: Colors.white),
                              ),
                            ),
                      onPressed: isButtonDisabled
                          ? null
                          : () {
                              if (_formKey.currentState.validate()) {
                                if (checkboxValue == false) {
                                  _showSnackBar(
                                      "Please confirm you have read our data protection terms.");
                                } else {
                                  setState(() => isButtonDisabled = true);
                                  setState(() {
                                    enteredName = nameController.text;
                                    enteredEmail = emailController.text;
                                    enteredPassword = passwordController.text;
                                    enteredPhoneNumber =
                                        int.parse(phoneNumberController.text);
                                    enteredPostcode = postcodeController.text;
                                    enteredStreetAddress =
                                        streetAddressController.text;
                                    enteredCity = cityController.text;
                                  });
                                  queryBuilder(
                                          widget.screen,
                                          enteredName,
                                          enteredEmail,
                                          enteredPassword,
                                          enteredPhoneNumber,
                                          enteredPostcode,
                                          enteredStreetAddress,
                                          enteredCity,
                                          enteredDistanceToTravel)
                                      .then((data) {
                                    if (data["createUser"]["name"] != null) {
                                      navigateToPage();
                                      reset();
                                    }
                                  });
                                }
                              }
                            },
                    ),
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  void reset() {
    nameController.text = "";
    emailController.text = "";
    passwordController.text = "";
    password2Controller.text = "";
    phoneNumberController.text = "";
    postcodeController.text = "";
    streetAddressController.text = "";
    cityController.text = "";

    setState(() {
      enteredName = "";
      enteredEmail = "";
      enteredPassword = "";
      enteredPhoneNumber = 0;
      enteredPostcode = "";
      enteredStreetAddress = "";
      enteredCity = "";
      enteredDistanceToTravel = 5.0;
    });
  }

  navigateToPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login(screen: "registration")),
    );
  }

  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future queryBuilder(userType, name, email, password, phoneNumber, postcode,
      streetAddress, city, distanceToTravel) async {
    String registrationQuery = '''mutation registrationQuery {
  createUser(userInput: {name: "$name" email: "$email" phoneNumber: "$phoneNumber" password: "$password" postcode: "$postcode" streetAddress: "$streetAddress" city: "$city" distanceToTravel: $distanceToTravel userType: "$userType"}) {
    name
  }
  }''';
    final HttpLink httpLink = HttpLink(
      uri: 'http://helping-hand-kjc.herokuapp.com/graphql',
    );
    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
    final response = await client
        .mutate(MutationOptions(documentNode: gql(registrationQuery)));

    if (response.loading) {
      return CircularProgressIndicator(backgroundColor: Colors.green);
    } else {
      Map user = response.data;
      return user;
    }
  }
}
