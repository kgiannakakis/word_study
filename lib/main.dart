import 'package:flutter/material.dart';
import 'wordstudy.dart';

void main() => runApp(new WordStudyApp());

class WordStudyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Word Study',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new WordStudy(),
    );
  }
}

