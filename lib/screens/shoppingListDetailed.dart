import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
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
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                    "${shoppingListData["helpee"]["name"]} sent this request on $formattedDate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
