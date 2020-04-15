import 'dart:core';
import 'package:flutter/material.dart';
import './imageCapture.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class HelpeeDashboard extends StatefulWidget {
  final Map userData;
  HelpeeDashboard({Key key, this.userData}) : super(key: key);
  @override
  _HelpeeDashboardState createState() => _HelpeeDashboardState();
}

class _HelpeeDashboardState extends State<HelpeeDashboard> {
  Map shoppingListData;
  DateTime parsedDate;
  bool orderReceived = false;

  void setShoppingList(shoppingList) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(
            int.parse(shoppingList["createdAt"]) * 1000)
        .toLocal();
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green))));
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Current Shopping Order")),
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${shoppingListData["listImage"]}',
                    imageSemanticLabel: 'My Shopping List',
                    height: 325.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 7.5),
                  child: Text(
                      "Order status is: ${shoppingListData["orderStatus"]}"),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 7.5),
                  child: Text("Date created: $parsedDate"),
                ),
                if (shoppingListData["volunteer"] == null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 7.5),
                    child: Text(
                      "Volunteer is not yet assigned to your order. \nPlease check back later",
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (shoppingListData["volunteer"] != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text("Contact volunteer: phone number"),
                  ),
                if (orderReceived == false)
                  RaisedButton(
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
                      "Order Received",
                      textScaleFactor: 1.2,
                    ),
                  ),
                if (orderReceived == true)
                  Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text("You have marked your order as complete."))
              ],
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
    print(response.data);
    return shoppingListUpdates;
  }
}
