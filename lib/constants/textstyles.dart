import 'package:flutter/material.dart';

class MyTextThemes {
  static TextStyle textHeading =
      const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle bodyTextStyle = TextStyle(
      fontSize: 20, color: Colors.teal[800], fontStyle: FontStyle.normal);

  static TextStyle chatStyle =
      TextStyle(fontSize: 18,decorationStyle: TextDecorationStyle.dashed, overflow: TextOverflow.ellipsis);
}
