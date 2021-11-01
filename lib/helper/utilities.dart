import 'package:flutter/material.dart';

class Util {
  static List<Widget> loadingCircular({String loadingLabel = "Loading..."}) {
    return [
      SizedBox(
        child: CircularProgressIndicator(),
        width: 50,
        height: 50,
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(loadingLabel),
      ),
    ];
  }
}
