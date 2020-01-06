import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:wish_list/models/article.dart';
import 'package:wish_list/models/databaseClient.dart';

class AddArticle extends StatefulWidget {

  int id;

  AddArticle(int id) {
    this.id = id;
  }

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {

  String image;
  String name;
  String price;
  String store;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Add an article"),
        actions: <Widget>[
          FlatButton(
            onPressed: add,
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 4.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (image == null)
                  ? Image.network("https://cdn.pixabay.com/photo/2015/07/15/11/53/woodtype-846089_960_720.jpg")
                      : Image.file(File(image)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.camera_enhance),
                        onPressed: () => getImage(ImageSource.camera),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: () => getImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                  textField(TypeTextField.name, "Name"),
                  textField(TypeTextField.price, "Price"),
                  textField(TypeTextField.store, "Store"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextField textField(TypeTextField type, String label) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: (String string) {
        switch (type) {
          case TypeTextField.name:
            name = string;
            break;
          case TypeTextField.price:
            price = string;
            break;
          case TypeTextField.store:
            store = string;
            break;
        }
      },
    );
  }

  void add() {
    if (name != null) {
      Map<String, dynamic> map = { 'name': name, 'item': widget.id };
      if (price != null) {
        map['price'] = price;
      }
      if (store != null) {
        map['store'] = store;
      }
      if (image != null) {
        map['image'] = image;
      }
      Article article = new Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        name = null;
        price = null;
        store = null;
        image = null;
        Navigator.pop(context);
      });
    }
  }

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker.pickImage(source: source);
    setState(() {
      image = newImage.path;
    });
  }
}

enum TypeTextField { name, price, store }