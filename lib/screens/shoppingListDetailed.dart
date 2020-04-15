import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../transformers.dart';

class shoppingListDetailed extends StatelessWidget {
  final Map shoppingListData;

  const shoppingListDetailed({Key key, @required this.shoppingListData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formattedDate = formatDate(shoppingListData["createdAt"]);
    print(shoppingListData);
    return Scaffold(
      appBar: AppBar(
          title: Text("${shoppingListData["helpee"]["name"]}'s Shopping List")),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        child: Center(
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
                      image: '${shoppingListData["listImage"]}',
                      imageSemanticLabel: 'My Shopping List',
                      height: 325.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                    "${shoppingListData["helpee"]["name"]} sent this request on $formattedDate"),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: null,
                child: Text(
                  "Help ${shoppingListData["helpee"]["name"]}!",
                  textScaleFactor: 1.2,
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  return _launchURL(
                      shoppingListData["helpee"]["locationLatLng"][0],
                      shoppingListData["helpee"]["locationLatLng"][1]);
                },
                child: Text(
                  "View ${shoppingListData["helpee"]["name"]}'s Location",
                  textScaleFactor: 1.2,
                ),
              ),
            ],
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
