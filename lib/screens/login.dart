import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String enteredEmailAddress = "";
  String enteredPassword = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
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
                  reset();
                });
              },
              child: Text(
                "Login",
                textScaleFactor: 1.2,
              ),
            )
          ],
        ),
      ),
    );
  }

  void reset() {
    print(enteredEmailAddress);
    print(enteredPassword);
//clears input boxes on screen
    emailController.text = "";
    passwordController.text = "";
//clears state
    setState(() {
      enteredEmailAddress = "";
      enteredPassword = "";
    });

    print(enteredEmailAddress);
    print(enteredPassword);
  }
}

// child: Text(
//   'Text with a background color',
//   style: Theme.of(context).textTheme.title,
// ),
// floatingActionButton: Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme:
//               Theme.of(context).colorScheme.copyWith(secondary: Colors.yellow),
//         ),
// child: FloatingActionButton(
//           onPressed: null,
//           child: Icon(Icons.add),
//         ),
