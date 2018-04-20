import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:word_study/wordstudy.dart';
import 'package:word_study/quizsettingswidget.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/quiz.dart';
import 'package:word_study/words/quizinstance.dart';
import 'package:word_study/files/fileservice.dart';
import 'package:word_study/words/quizprovider.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {

  List<Quiz> _quizzes = <Quiz>[];
  final FileService _fileService = new FileService();
  final QuizProvider _quizProvider = new QuizProvider();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();

    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    await _quizProvider.init();

    final directory = await _fileService.localPath;
    File file = new File('$directory/${_quizProvider.builtinFilename}');
    bool exists = await file.exists();

    if (!exists) {
      WordProvider wordProvider = new WordProvider();
      await wordProvider.init();
      await wordProvider.store(_quizProvider.builtinFilename);
    }

    setState(() {
      _quizzes = _quizProvider.allQuizzes;
    });
  }

  void _start(int i) async {
    QuizInstance quizInstance = new QuizInstance(_quizzes[i]);
    bool ok = await quizInstance.init();
    if (ok) {
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) => new WordStudy(quizInstance: quizInstance,
                currentWord: 0)
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

  void _gotoCreateQuiz() async {
    await Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) => new QuizSettingsWidget()
        )
    );
    await _loadQuizzes();
  }

  Widget _buildRow(int i) {
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new ListTile(
            title: new Text(_quizzes[i].name, style: _biggerFont),
            onTap: () { _start(i); }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Word Study"),
        ),
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 2*_quizzes.length,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return new Divider();

            final index = position ~/ 2;

            return _buildRow(index);
          }),
      floatingActionButton: new FloatingActionButton(onPressed: _gotoCreateQuiz,
                                                     child: new Icon(Icons.add)),
    );
  }

}