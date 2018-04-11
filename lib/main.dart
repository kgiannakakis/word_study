import 'package:flutter/material.dart';
import 'package:word_study/words/webwordprovider.dart';
import 'package:word_study/wordstudy.dart';

void main() => runApp(new WordStudyApp());

class WordStudyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Word Study',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new WordStudy(
        wordProvider: new WebWordProvider("https://dl.dropboxusercontent.com/s/rwjl6apmu0xilyq/test.xlsx?dl=0"),
      )
    );
  }
}

