import 'package:flutter/material.dart';

class Util {
  static List<Widget> loadingCircular({String loadingLabel = "Loading..."}) {
    return [
      const SizedBox(
        child: CircularProgressIndicator(),
        width: 50,
        height: 50,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(loadingLabel),
      ),
    ];
  }
}
