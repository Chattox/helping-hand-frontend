import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

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
    if (shoppingListsData == null) {
      return Center(
          child: Container(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green))));
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Neighbours To Help")),
        backgroundColor: Theme.of(context).accentColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Shopping Lists Available For Pickup In You Area:"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingListsData.length,
                itemBuilder: (BuildContext context, int index) {
                  var formattedDate =
                      formatDate(shoppingListsData[index]["createdAt"]);
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.format_list_bulleted),
                      title: Text(shoppingListsData[index]["helpee"]["name"]),
                      subtitle: Text(formattedDate),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
            ),
          ],
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
      List shoppingListsRaw = response.data["filterByDistance"];
      return shoppingListsRaw;
    }
  }
}

formatDate(date) {
  var number = int.parse(date);
  assert(number is int);
  var formattedDate = DateTime.fromMillisecondsSinceEpoch(number);
  var doubleformattedDate = DateFormat.yMMMMEEEEd().format(formattedDate);
  return doubleformattedDate;
}
