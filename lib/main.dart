import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/imageCapture.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final HttpLink httpLink = HttpLink(
    uri: 'http://helping-hand-kjc.herokuapp.com/graphql',
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    ),
  );
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final client;
  MyApp({Key key, @required this.client}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appName = 'Helping Hand';

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.green[400],
          primaryColorDark: Colors.green[900],
          primaryColorLight: Colors.green[600],
          accentColor: Colors.green[100],

          // Define the default font family.
          fontFamily: 'Roboto',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
          ),
        ),
        // home: ImageCapture(),
        home: MyHomePage(
          title: appName,
        ),
      ),
    );
  }
}
