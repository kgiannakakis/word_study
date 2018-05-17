import 'package:flutter/material.dart';

class ListItemTextStyle {
  static TextStyle display5(BuildContext context) {
    return Theme.of(context).textTheme.display1.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        color: Colors.black
    );
  }
}