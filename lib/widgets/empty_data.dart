import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(
          "No data was found",
        textScaleFactor: 2.0,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}