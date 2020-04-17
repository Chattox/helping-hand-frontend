import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './screens/home.dart';
import './screens/login.dart';

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

class Routes {
  static const String loginPage = '/login';
  static const String homePage = '/';
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
        debugShowCheckedModeBanner: false,
        routes: {
          Routes.loginPage: (BuildContext context) => Login(screen: 'helpee'),
        },
        title: appName,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.green[400],
          primaryColorDark: Colors.green[900],
          primaryColorLight: Colors.green[600],
          accentColor: Colors.green[100],

          // Define the default font family.
          fontFamily: 'Lato',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 50.0, fontFamily: 'LondrinaShadow'),
            body1: TextStyle(
                fontSize: 16.0, fontFamily: 'Lato', color: Colors.green[900]),
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
