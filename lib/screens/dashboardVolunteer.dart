import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class VolunteerDashboard extends StatefulWidget {
  final Map userData;
  VolunteerDashboard({Key key, @required this.userData}) : super(key: key);
  @override
  _VolunteerDashboardState createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  var shoppingListsData;

  void setShoppingLists(shoppingLists) {
    setState(() {
      shoppingListsData = shoppingLists;
    });
  }

  @override
  void initState() {
    super.initState();
    queryBuilder().then((shoppingLists) {
      setShoppingLists(shoppingLists);
    });
  }

  Widget build(BuildContext context) {
    print("STATE: ${shoppingListsData}");
    if (shoppingListsData == null) {
      return Center(
          child: Container(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green))));
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Dashboard")),
        backgroundColor: Theme.of(context).accentColor,
        body: ListView.builder(
          itemCount: shoppingListsData.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(shoppingListsData[index]["helpee"]["name"]),
                subtitle: Text(shoppingListsData[index]["createdAt"]));
          },
        ),
      );
    }
  }

  Future queryBuilder() async {
    String shoppingListsQuery = '''query shoppingListsQuery{
  filterByDistance(target: "5e95d91699c1d600177feb67") {
    _id
    helpee {
      name
      locationLatLng
    }
    createdAt
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
        await client.query(QueryOptions(documentNode: gql(shoppingListsQuery)));
    if (response.loading) {
      return CircularProgressIndicator(backgroundColor: Colors.green);
    } else {
      List shoppingLists = response.data["filterByDistance"];
      return shoppingLists;
    }
  }
}
