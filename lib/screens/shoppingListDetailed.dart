import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../transformers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class shoppingListDetailed extends StatefulWidget {
  GoogleMapController mapController;
  final String shoppingListId;
  final String volunteerId;
  shoppingListDetailed(
      {Key key, @required this.shoppingListId, @required this.volunteerId})
      : super(key: key);

  @override
  _shoppingListDetailedState createState() => _shoppingListDetailedState();
  Set<Marker> markers = Set();
}

class _shoppingListDetailedState extends State<shoppingListDetailed> {
  var singleShoppingListData;

  void setSingleShoppingList(shoppingList) {
    setState(() {
      singleShoppingListData = shoppingList;
    });
  }

  @override
  void initState() {
    // print("ID ${widget.shoppingListId} ${widget.volunteerId}");
    super.initState();
    getShoppingListById(widget.shoppingListId).then((shoppingListData) {
      setSingleShoppingList(shoppingListData);
    });
  }

  Widget build(BuildContext context) {
    if (this.singleShoppingListData == null) {
      return Center(
          child: Container(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green))));
    } else {
      // print("in build: >> ${this.singleShoppingListData}");
      widget.markers.add(
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(
              this.singleShoppingListData["helpee"]["locationLatLng"][0],
              this.singleShoppingListData["helpee"]["locationLatLng"][1]),
          infoWindow: InfoWindow(
              title:
                  "${this.singleShoppingListData["helpee"]["name"]}'s approximate location"),
        ),
      );
      var formattedDate = formatDate(this.singleShoppingListData["createdAt"]);
      return Scaffold(
        appBar: AppBar(
            title: Text(
                "${this.singleShoppingListData["helpee"]["name"]}'s Shopping List")),
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      pickUpShoppingList(
                          widget.shoppingListId, widget.volunteerId);
                    },
                    child: Text(
                      "Help ${this.singleShoppingListData["helpee"]["name"]}!",
                      textScaleFactor: 1.2,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        )),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: '${this.singleShoppingListData["listImage"]}',
                          imageSemanticLabel: 'My Shopping List',
                          height: 325.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                        "${this.singleShoppingListData["helpee"]["name"]} sent this request on $formattedDate"),
                  ),
                  Container(
                    height: 300.0,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          widget.mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              this.singleShoppingListData["helpee"]
                                  ["locationLatLng"][0],
                              this.singleShoppingListData["helpee"]
                                  ["locationLatLng"][1]),
                          zoom: 15,
                        ),
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        markers: widget.markers,
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      return _launchURL(
                          this.singleShoppingListData["helpee"]
                              ["locationLatLng"][0],
                          this.singleShoppingListData["helpee"]
                              ["locationLatLng"][1]);
                    },
                    child: Text(
                      "Open ${this.singleShoppingListData["helpee"]["name"]}'s Location in Google Maps",
                      textScaleFactor: 1.2,
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

  _launchURL(lat, lon) async {
    String url = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future getShoppingListById(shoppingListId) async {
    String shoppingListByIdQuery = '''query shoppingListByIdQuery {
  shoppingListById(id: "$shoppingListId") {orderStatus createdAt listImage helpee  {name phoneNumber postcode streetAddress city locationLatLng}}
}
''';
    final HttpLink httpLink = HttpLink(
      uri: 'http://helping-hand-kjc.herokuapp.com/graphql',
    );
    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
    final response = await client
        .query(QueryOptions(documentNode: gql(shoppingListByIdQuery)));
    Map result = response.data["shoppingListById"];
    return result;
  }

  Future pickUpShoppingList(shoppingListId, volunteerId) async {
    print("in query $shoppingListId, $volunteerId");
    String pickUpShoppingListQuery = '''mutation pickUpShoppingListQuery {
  updateShoppingList(listId: "$shoppingListId", volunteerId: "$volunteerId") {orderStatus}
}
''';
    // final HttpLink httpLink = HttpLink(
    //   uri: 'http://helping-hand-kjc.herokuapp.com/graphql',
    // );
    // GraphQLClient client = GraphQLClient(
    //   cache: InMemoryCache(),
    //   link: httpLink,
    // );
    // final response = await client
    //     .query(QueryOptions(documentNode: gql(pickUpShoppingListQuery)));
    // String result = response.data["updateShoppingList"];
    // print(result);
    // return result;
  }
}
