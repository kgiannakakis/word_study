import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:word_study/wordstudy.dart';
import 'package:word_study/fileslist.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/quiz.dart';
import 'package:word_study/words/quizsettings.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {

  List<Quiz> _quizzes = <Quiz>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();

    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    const builtinFilename = '__builtin';

    final directory = await getApplicationDocumentsDirectory();
    File file = new File('${directory.path}/$builtinFilename');
    bool exists = await file.exists();

    if (!exists) {
      WordProvider wordProvider = new WordProvider();
      await wordProvider.init();
      await wordProvider.store(builtinFilename);
    }

    const int wordsCount = 10;
    const int optionsCount = 4;
    QuizSettings quizSettings = new QuizSettings(wordsCount: wordsCount, optionsCount: optionsCount);
    Quiz builtin = new Quiz(name: "Demo", settings: quizSettings, filenames: [builtinFilename]);
    List<Quiz> quizzes = <Quiz>[builtin];
    setState(() {
      _quizzes = quizzes;
    });
  }

  void _start(int i) async {
    bool ok = await _quizzes[i].init();
    if (ok) {
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) => new WordStudy(quiz: _quizzes[i],
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

  void _gotoFilesList() {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) => new FilesList()
        )
    );
  }

//  void _goToGoogleDrive(BuildContext context) {
//    Navigator.of(context).push(
//        new MaterialPageRoute(
//            builder: (context) => new SignInDemo()
//        )
//    );
//  }

//  Future<bool> _initQuiz() async {
//    final directory = await getApplicationDocumentsDirectory();
//    File file = new File('${directory.path}/test.xlsx');
//    bool exists = await file.exists();
//    print(exists);
//    if (!exists) {
//      print('Loading from web');
//      WordProvider wordProvider = new WebWordProvider(
//          "https://dl.dropboxusercontent.com/s/rwjl6apmu0xilyq/test.xlsx?dl=0");
//      await wordProvider.init();
//      await wordProvider.store('test.xlsx');
//    }
//    QuizSettings quizSettings = new QuizSettings(wordsCount: wordsCount, optionsCount: optionsCount);
//    _quiz = new Quiz(settings: quizSettings, filenames: <String>['test.xlsx']);
//    bool ok = await _quiz.init();
//    return ok;
//  }

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
      floatingActionButton: new FloatingActionButton(onPressed: _gotoFilesList,
                                                     child: new Icon(Icons.add)),
    );
  }

}