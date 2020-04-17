import 'dart:core';
import 'package:flutter/material.dart';
import 'package:helping_hand_frontend/transformers.dart';
import './imageCapture.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpeeDashboard extends StatefulWidget {
  final Map userData;
  HelpeeDashboard({Key key, this.userData}) : super(key: key);
  @override
  _HelpeeDashboardState createState() => _HelpeeDashboardState();
}

class _HelpeeDashboardState extends State<HelpeeDashboard> {
  String parsedDate;
  Map shoppingListData;
  bool orderReceived = false;

  void setShoppingList(shoppingList) {
    var date = formatDate(shoppingList["createdAt"]);

    setState(() {
      shoppingListData = shoppingList;
      parsedDate = date;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.userData["shoppingListId"].length == 0) {
      return null;
    } else {
      shoppingListBuilder(widget.userData["shoppingListId"][0]["_id"])
          .then((shoppingList) {
        setShoppingList(shoppingList);
      });
    }
  }

  Widget build(BuildContext context) {
    if (widget.userData["shoppingListId"].length == 0) {
      return ImageCapture(userId: widget.userData["_id"]);
    }
    if (shoppingListData == null) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Shopping List",
            style: GoogleFonts.londrinaShadow(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 1.5),
                fontSize: 40.0),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          padding: EdgeInsets.all(5.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset('images/groceries/bread.png', width: 60.0),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                    child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: '${shoppingListData["listImage"]}',
                        imageSemanticLabel: 'My Shopping List',
                        height: 275.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 7.5),
                    child: Text(
                        "Order status is: ${shoppingListData["orderStatus"]}",
                        style: Theme.of(context).textTheme.body1),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 7.5),
                    child: Text("Date: $parsedDate",
                        style: Theme.of(context).textTheme.body1),
                  ),
                  if (shoppingListData["volunteer"] != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.5),
                      child: Text(
                          "${shoppingListData["volunteer"]["name"]} is assigned to your order. \n They can get in touch with you via your phone number.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.body1),
                    ),
                  if (shoppingListData["volunteer"] == null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.5),
                      child: Text(
                          "Volunteer is not yet assigned to your order. \nPlease check back later",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.body1),
                    ),
                  if (shoppingListData["volunteer"] != null)
                    Text(
                        "Contact ${shoppingListData["volunteer"]["name"]}: ${shoppingListData["volunteer"]["phoneNumber"]}",
                        style: Theme.of(context).textTheme.body1),
                  if (orderReceived == false)
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ButtonTheme(
                        height: 60.0,
                        minWidth: 400.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 3.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            updateShoppingListStatus(
                                    widget.userData["shoppingListId"][0]["_id"])
                                .then((data) {
                              setState(() {
                                orderReceived = true;
                              });
                            });
                          },
                          child: Text(
                            "I've received my order!",
                            style: GoogleFonts.pangolin(
                              textStyle: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (orderReceived == true)
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text("You have marked your order as complete.",
                          style: Theme.of(context).textTheme.body1),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: 10.0, left: 10.0, bottom: 10.0, top: 5.0),
                    child: ButtonTheme(
                      height: 60.0,
                      minWidth: 400.0,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 3.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Logout",
                            style: GoogleFonts.pangolin(
                              textStyle: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            return Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Future shoppingListBuilder(shoppingListId) async {
    String shoppingListQuery = '''query shoppingListQuery {
  shoppingListById(id: "$shoppingListId") {
    listImage
    orderStatus
    createdAt
    updatedAt
    volunteer {
      name
      phoneNumber
    }
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
        await client.query(QueryOptions(documentNode: gql(shoppingListQuery)));

    if (response.loading) {
      return CircularProgressIndicator(backgroundColor: Colors.green);
    } else {
      Map shoppingList = response.data["shoppingListById"];
      return shoppingList;
    }
  }

  Future updateShoppingListStatus(shoppingListId) async {
    String shoppingListQuery = '''mutation shoppingListUpdate {
  updateShoppingList(listId: "$shoppingListId" helpeeComplete: true) {
    orderStatus
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
        await client.query(QueryOptions(documentNode: gql(shoppingListQuery)));
    Map shoppingListUpdates = response.data["updateShoppingList"];
    return shoppingListUpdates;
  }
}
