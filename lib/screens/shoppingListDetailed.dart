import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../transformers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class shoppingListDetailed extends StatefulWidget {
  GoogleMapController mapController;
  shoppingListDetailed({Key key, @required this.shoppingListData})
      : super(key: key);

  @override
  _shoppingListDetailedState createState() => _shoppingListDetailedState();
  final Map shoppingListData;
  Set<Marker> markers = Set();
}

class _shoppingListDetailedState extends State<shoppingListDetailed> {
  @override
  Widget build(BuildContext context) {
    widget.markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(widget.shoppingListData["helpee"]["locationLatLng"][0],
            widget.shoppingListData["helpee"]["locationLatLng"][1]),
        infoWindow: InfoWindow(
            title:
                "${widget.shoppingListData["helpee"]["name"]}'s approximate location"),
      ),
    );
    var formattedDate = formatDate(widget.shoppingListData["createdAt"]);
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "${widget.shoppingListData["helpee"]["name"]}'s Shopping List")),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        image: '${widget.shoppingListData["listImage"]}',
                        imageSemanticLabel: 'My Shopping List',
                        height: 325.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                      "${widget.shoppingListData["helpee"]["name"]} sent this request on $formattedDate"),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: null,
                  child: Text(
                    "Help ${widget.shoppingListData["helpee"]["name"]}!",
                    textScaleFactor: 1.2,
                  ),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    return _launchURL(
                        widget.shoppingListData["helpee"]["locationLatLng"][0],
                        widget.shoppingListData["helpee"]["locationLatLng"][1]);
                  },
                  child: Text(
                    "Open ${widget.shoppingListData["helpee"]["name"]}'s Location in Google Maps",
                    textScaleFactor: 1.2,
                  ),
                ),
                Container(
                  height: 300.0,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        widget.mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            widget.shoppingListData["helpee"]["locationLatLng"]
                                [0],
                            widget.shoppingListData["helpee"]["locationLatLng"]
                                [1]),
                        zoom: 15,
                      ),
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      markers: widget.markers,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(lat, lon) async {
    String url = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// final Marker marker = Marker(markerId: )
