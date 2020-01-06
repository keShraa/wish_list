import 'package:flutter/material.dart';
import 'package:wish_list/models/item.dart';
import 'package:wish_list/models/article.dart';
import 'package:wish_list/widgets/empty_data.dart';
import 'package:wish_list/widgets/add_article.dart';
import 'package:wish_list/models/databaseClient.dart';
import 'dart:io';

class ItemDetails extends StatefulWidget {
  Item item;

  ItemDetails(Item item) {
    this.item = item;
  }

  @override
  _ItemDetailsState createState() => new _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {

  List<Article> articles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseClient().allArticles(widget.item.id).then((list) {
      setState(() {
        articles = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContext) {
                return AddArticle(widget.item.id);
              })).then((value) {
                DatabaseClient().allArticles(widget.item.id).then((list) {
                  setState(() {
                    articles = list;
                  });
                });
              });
            },
            child: Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: (articles == null || articles.length == 0)
      ? EmptyData()
          : GridView.builder(
        itemCount: articles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, i) {
            Article article = articles[i];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(article.name, textScaleFactor: 1.4,),
                  (article.image == null)
                  ? Image.network("https://cdn.pixabay.com/photo/2015/07/15/11/53/woodtype-846089_960_720.jpg")
                      : Image.file(File(article.image)),
                  Text((article.price == null)? 'No price': "Price: ${article.price}"),
                  Text((article.store == null)? 'No store': "Store: ${article.price}"),
                ],
              ),
            );
          }),
    );
  }
}