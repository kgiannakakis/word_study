import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:word_study/signin.dart';
import 'package:word_study/wordstudy.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/webwordprovider.dart';
import 'package:word_study/words/quiz.dart';
import 'package:word_study/words/quizsettings.dart';

class Home extends StatelessWidget {

  Quiz _quiz;
  final int wordsCount = 10;
  final int optionsCount = 4;

  void _start(BuildContext context) async {
    bool ok = await _initQuiz();
    if (ok) {
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) => new WordStudy(quiz: _quiz,
                currentWord: 0,
                wordsCount: wordsCount,)
          )
      );
    }
    else {
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Failed to start quiz'),
          backgroundColor: Colors.red
      ));
    }
  }

  void _goToGoogleDrive(BuildContext context) {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) => new SignInDemo()
        )
    );
  }

  Future<bool> _initQuiz() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = new File('${directory.path}/test.xlsx');
    bool exists = await file.exists();
    print(exists);
    if (!exists) {
      print('Loading from web');
      WordProvider wordProvider = new WebWordProvider(
          "https://dl.dropboxusercontent.com/s/rwjl6apmu0xilyq/test.xlsx?dl=0");
      await wordProvider.init();
      await wordProvider.store('test.xlsx');
    }
    QuizSettings quizSettings = new QuizSettings(wordsCount: wordsCount, optionsCount: optionsCount);
    _quiz = new Quiz(settings: quizSettings, filenames: <String>['test.xlsx']);
    bool ok = await _quiz.init();
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Word Study"),
        ),
        body: new Builder(
            builder: (BuildContext context) {
              return new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Column(
                        children: <Widget>[
                          new Expanded(child: new Center(
                              child: new RaisedButton(
                                  onPressed: () {_start(context);},
                                  child: new Text("Start"))
                          )),
                          new Expanded(child: new Center(
                              child: new RaisedButton(
                                onPressed: () {_goToGoogleDrive(context);},
                                child: new Text("Google Drive"),)
                          ))
                        ],
                      )
                    )
                  ]);
            }
        )
    );
  }

}