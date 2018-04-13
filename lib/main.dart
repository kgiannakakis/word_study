import 'package:flutter/material.dart';
import 'package:word_study/home.dart';
import 'package:word_study/signin.dart';

void main() => runApp(new WordStudyApp());

class WordStudyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Word Study',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new SignInDemo()
    );
  }
}

