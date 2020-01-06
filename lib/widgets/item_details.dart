import 'package:flutter/material.dart';
import 'package:wish_list/models/item.dart';

class ItemDetails extends StatefulWidget {
  Item item;

  ItemDetails(Item item) {
    this.item = item;
  }

  @override
  _ItemDetailsState createState() => new _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
    );
  }
}