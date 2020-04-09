import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String enteredName = '';
  String enteredEmail = '';
  String enteredPassword = '';
  int enteredNumber = 0;
  String enteredPostcode = '';
  String enteredStreetAddress = '';
  String enteredCity = "";
  int enteredDistanceToTravel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration")),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 7.0, right: 15.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
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
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.vpn_key,
                        color: Theme.of(context).primaryColor),
                  ),
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
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Telephone Number',
                    icon:
                        Icon(Icons.call, color: Theme.of(context).primaryColor),
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
              Padding(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                child: TextFormField(
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
              Padding(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
                child: TextFormField(
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
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Register",
                  textScaleFactor: 1.2,
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      enteredName = nameController.text;
                      enteredEmail = emailController.text;
                      enteredPassword = passwordController.text;
                      enteredNumber = int.parse(phoneNumberController.text);
                      enteredPostcode = postcodeController.text;
                      reset();
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    nameController.text = "";
    emailController.text = "";
    passwordController.text = "";
    phoneNumberController.text = "";
    setState(() {
      enteredName = "";
      enteredEmail = "";
      enteredPassword = "";
      enteredNumber = 0;
    });
  }
}

// class Registration extends StatefulWidget {
//   @override
//   _RegistrationState createState() => _RegistrationState();
// }

// class _RegistrationState extends State<Registration> {

//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Text("Registration Page"));
//   }
// }
