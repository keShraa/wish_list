import 'package:flutter/material.dart';
import 'dart:async';
import 'package:wish_list/models/item.dart';
import 'package:wish_list/widgets/empty_data.dart';
import 'package:wish_list/models/databaseClient.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  String newList;
  List<Item> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            onPressed: (() => add(null)),
            child: Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: (items == null || items.length == 0)
          ? new EmptyData()
          : new ListView.builder(
        itemCount: items.length,
          itemBuilder: (context, i) {
          Item item = items[i];
            return ListTile(
              title: Text(item.name),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  DatabaseClient().delete(item.id, 'item').then((int) {
                    getData();
                  });
                },
              ),
              leading: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (() => add(item)),
              ),
            );
          }
      ),
    );
  }

  Future<Null> add(Item item) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text("Add a wish list"),
            content: TextField(
              decoration: InputDecoration(
                  labelText: "List:",
                  hintText: (item == null) ? "eg: My next video games" : item.name,
              ),
              onChanged: (String str) {
                newList = str;
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(buildContext),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () {
                  // Ajouter le code pour pouvoir ajouter à la base de données
                  if (newList != null) {
                    if (item == null) {
                      item = new Item();
                      Map<String, dynamic> map = { 'name': newList };
                      item.fromMap(map);
                    } else {
                      item.name = newList;
                    }
                    DatabaseClient().upsertItem(item).then((i) => getData());
                    newList = null;
                  }

                  Navigator.pop(buildContext);
                },
                child: Text("Submit"),
              ),
            ],
          );
        }
    );
  }

  void getData() {
    DatabaseClient().allItems().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }

}
