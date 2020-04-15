import 'dart:core';
import 'package:flutter/material.dart';
import './imageCapture.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HelpeeDashboard extends StatefulWidget {
  final Map userData;
  HelpeeDashboard({Key key, @required this.userData}) : super(key: key);
  @override
  _HelpeeDashboardState createState() => _HelpeeDashboardState();
}

class _HelpeeDashboardState extends State<HelpeeDashboard> {
  Map shoppingListData;

  void setShoppingList(shoppingList) {
    setState(() {
      shoppingListData = shoppingList;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.userData["shoppingListId"].length == 0) {
      return null;
    } else {
      queryBuilder(widget.userData["shoppingListId"][0]["_id"])
          .then((shoppingList) {
        setShoppingList(shoppingList);
      });
    }
  }

  Widget build(BuildContext context) {
    print("shopping list data in build >>> $shoppingListData");
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
        appBar: AppBar(title: Text("Current Shopping Orders")),
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text("My Current Shopping Order"),
                ),
                FadeInImage.assetNetwork(
                  placeholder: 'images/loading-spinner-green.gif',
                  image: '${shoppingListData["listImage"]}',
                  height: 250.0,
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    //send mutation to update shoppinglist status <<<<<<
                  },
                  child: Text(
                    "Order Received",
                    textScaleFactor: 1.2,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  Future queryBuilder(shoppingListId) async {
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
}
