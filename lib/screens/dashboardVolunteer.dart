import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './shoppingListDetailed.dart';
import '../transformers.dart';

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
        appBar: AppBar(title: Text("Your Neighbours Needing Help")),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => shoppingListDetailed(
                                      shoppingListData:
                                          shoppingListsData[index],
                                    )));
                      },
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
    print(widget.userData["_id"]);
    String shoppingListsQuery = '''query shoppingListsQuery{
  filterByDistance(target: "${widget.userData["_id"]}") {
		_id
    orderStatus
    helpee {
      name
      locationLatLng
      phoneNumber
      postcode
      streetAddress
      city
    } 
    listImage   
    createdAt
    updatedAt
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
