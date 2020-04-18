import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../transformers.dart';
import '../screens/dashboardVolunteer.dart';

class shoppingListDetailed extends StatefulWidget {
  GoogleMapController mapController;
  final String shoppingListId;
  // final String volunteerId;
  final Map volunteerData;
  final String screen;
  shoppingListDetailed(
      {Key key,
      @required this.shoppingListId,
      @required this.volunteerData,
      this.screen})
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
            automaticallyImplyLeading:
                (widget.screen == "dashboard") ? true : false,
            title: Text(
              "${this.singleShoppingListData["helpee"]["name"]}",
              style: GoogleFonts.londrinaShadow(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 1.5),
                  fontSize: 40.0),
            )),
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: (widget.screen == "dashboard")
                        ? Text(
                            "${this.singleShoppingListData["helpee"]["name"]} needs help with their below shopping list which they sent in on $formattedDate. Can you help them?",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColorDark),
                            ),
                          )
                        : Text(
                            "You are currently helping ${this.singleShoppingListData["helpee"]["name"]} with their below shopping list.",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColorDark),
                            ),
                          ),
                  ),
                  Center(
                    child: (widget.screen == "dashboard")
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 10.0),
                            child: ButtonTheme(
                              height: 60.0,
                              minWidth: 400.0,
                              child: RaisedButton.icon(
                                color: Theme.of(context).primaryColor,
                                icon: Icon(Icons.favorite_border,
                                    color: Colors.white),
                                onPressed: () {
                                  pickUpShoppingList(widget.shoppingListId,
                                      widget.volunteerData["_id"]);
                                },
                                label: Text(
                                  // "Help ${this.singleShoppingListData["helpee"]["name"]}!",
                                  "I can help!",
                                  style: GoogleFonts.pangolin(
                                    textStyle: TextStyle(
                                        fontSize: 25.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.white,
                          width: 5,
                        )),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: '${this.singleShoppingListData["listImage"]}',
                          imageSemanticLabel: 'My Shopping List',
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(right: 10.0),
                  //   child: Align(
                  //       alignment: Alignment.center,
                  //       child: Image.asset(
                  //         "images/groceries/mix.png",
                  //         width: 50.0,
                  //       )),
                  // ),
                  Center(
                      child: (widget.screen != "login")
                          ? Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                  "See below ${this.singleShoppingListData["helpee"]["name"]}'s approximate location.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  )),
                            )
                          : null),
                  Center(
                      child: (widget.screen == "login")
                          ? Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                  "Ready to deliver? Please take the bags to ${this.singleShoppingListData["helpee"]["name"]}'s exact address and call them on the below number to arrange safe exchange.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  )),
                            )
                          : null),
                  Center(
                      child: (widget.screen == "login")
                          ? Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                  "${this.singleShoppingListData["helpee"]["streetAddress"]}\n${this.singleShoppingListData["helpee"]["city"]}\n${this.singleShoppingListData["helpee"]["postcode"]}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 24,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  )),
                            )
                          : null),
                  Center(
                    child: (widget.screen == "login")
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 10.0,
                                right: 10.0),
                            child: ButtonTheme(
                              height: 60.0,
                              minWidth: 400.0,
                              child: RaisedButton.icon(
                                icon: Icon(Icons.call, color: Colors.white),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  return _callNumber(
                                      this.singleShoppingListData["helpee"]
                                          ["phoneNumber"]);
                                },
                                label: Text(
                                  "Call ${this.singleShoppingListData["helpee"]["name"]}",
                                  style: GoogleFonts.pangolin(
                                    textStyle: TextStyle(
                                        fontSize: 25.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.white,
                        width: 5,
                      )),
                      height: 300.0,
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
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                    child: ButtonTheme(
                      height: 60.0,
                      minWidth: 400.0,
                      child: RaisedButton.icon(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.location_on, color: Colors.white),
                        onPressed: () {
                          return _launchURL(
                              this.singleShoppingListData["helpee"]
                                  ["locationLatLng"][0],
                              this.singleShoppingListData["helpee"]
                                  ["locationLatLng"][1]);
                        },
                        label: Text(
                          "Open in Google Maps",
                          style: GoogleFonts.pangolin(
                            textStyle:
                                TextStyle(fontSize: 25.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: (widget.screen == "login")
                        ? Padding(
                            padding: EdgeInsets.only(
                                bottom: 20.0, left: 10.0, right: 10.0),
                            child: ButtonTheme(
                              height: 60.0,
                              minWidth: 400.0,
                              child: RaisedButton.icon(
                                color: Theme.of(context).primaryColorDark,
                                icon: Icon(Icons.loyalty, color: Colors.white),
                                onPressed: () {
                                  return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VolunteerDashboard(
                                                userData:
                                                    widget.volunteerData)),
                                  );
                                },
                                label: Text(
                                  "Mark it delivered",
                                  style: GoogleFonts.pangolin(
                                    textStyle: TextStyle(
                                        fontSize: 25.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  _callNumber(number) async {
    String url = 'tel:${number.toString()}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
    String pickUpShoppingListQuery = '''mutation pickUpShoppingListQuery {
  updateShoppingList(listId: "$shoppingListId", volunteerId: "$volunteerId") {orderStatus}
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
        .query(QueryOptions(documentNode: gql(pickUpShoppingListQuery)));
    String result = response.data["updateShoppingList"];
    return result;
  }
}
