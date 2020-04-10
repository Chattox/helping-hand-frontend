import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Login extends StatefulWidget {
  final String screen;
  Login({Key key, @required this.screen}) : super(key: key);
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
                loginUser();
                // reset();
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

//   void reset() {
//     print(enteredEmailAddress);
//     print(enteredPassword);
// //clears input boxes on screen
//     emailController.text = "";
//     passwordController.text = "";
// //clears state
//     setState(() {
//       enteredEmailAddress = "";
//       enteredPassword = "";
//     });

//     print(enteredEmailAddress);
//     print(enteredPassword);
//   }
// }

  loginUser() {
    print("hello");
    final query = """query LoginUser{
  login(email: "lehoczki.judit@gmail.com", password: "tester") {name userType shoppingListId {orderStatus}}
}""";
    return Query(
        options: QueryOptions(
          documentNode: gql(query),
        ),
        builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
          print("in query");
          if (result.loading) {
            print(result);
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data == null) {
            print(result);
            return Text("No data found");
          }
          print(result);
          return Text("Data found");
        });
  }
}
// class LoginQuery extends StatelessWidget {
//   final query = r"""query LoginUser{
//   login(email: "lehoczki.judit@gmail.com", password: "tester") {name userType shoppingListId {orderStatus}}
// }""";
//   @override
//   Widget build(BuildContext context) {
//     return Query();
//   }
// }

//  return Query(
//       options: QueryOptions(document: r"""query LoginUser{
//   login(email: "lehoczki.judit@gmail.com", password: "tester") {name userType shoppingListId {orderStatus}}
// }"""),
//       builder: (
//         QueryResult result, {
//         VoidCallback refetch,
//       }) {
//         if (result.data == null) {
//           return Text("No data found");
//         }
//         return Text("getting the query result back");
//       },
//     );
// navigateToPage() {
//   if (widget.screen == "volunteer") {
//     return Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => VolunteerDashboard()),
//     );
//   }
//   if (widget.screen == "helpee") {
//     return Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => HelpeeDashboard()),
//     );
//   }
// }

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
