import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
      // List<Map> sortedShoppingLists =
      //     shoppingLists.sort((m1, m2) => (m1.distance).compareTo(m2.distance));
      // setShoppingLists(sortedShoppingLists);
      setShoppingLists(shoppingLists);
    });
  }

  Widget build(BuildContext context) {
    print("userdata >>> ${widget.userData["_id"]}");
    if (shoppingListsData == null) {
      return Center(
          child: Container(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green))));
    } else {
      return Scaffold(
        appBar: AppBar(
            title: Text("The Ones To Help",
                style: GoogleFonts.londrinaShadow(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        letterSpacing: 1.5),
                    fontSize: 40.0))),
        backgroundColor: Theme.of(context).accentColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "See below your neighbours who would like some help with their shopping. Select one to see more details.",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColorDark),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingListsData.length,
                itemBuilder: (BuildContext context, int index) {
                  var formattedDate =
                      formatDate(shoppingListsData[index]["createdAt"]);
                  return Card(
                    child: ListTile(
                      leading: (shoppingListsData[index]["listImage"] != null)
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  shoppingListsData[index]["listImage"]),
                            )
                          : Icon(Icons.format_list_bulleted,
                              color: Theme.of(context).primaryColorDark,
                              size: 40.0),
                      title: Text(
                          "${shoppingListsData[index]["helpee"]["name"]} (${shoppingListsData[index]["distance"]} mi)",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          )),
                      subtitle: Text(formattedDate),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => shoppingListDetailed(
                              shoppingListId: shoppingListsData[index]["_id"],
                              volunteerId: widget.userData["_id"],
                            ),
                          ),
                        );
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
    distance
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
