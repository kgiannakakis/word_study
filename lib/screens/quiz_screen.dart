import 'dart:async';

import 'package:flutter/material.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/models/quiz_word.dart';
import 'package:word_study/screens/home_screen.dart';
import 'package:word_study/screens/option_widget.dart';
import 'package:word_study/screens/results_screen.dart';
import 'package:word_study/words/quiz_instance.dart';

class QuizScreen extends StatefulWidget {
  final QuizInstance quizInstance;
  final int currentWord;

  QuizScreen({this.quizInstance, this.currentWord});

  @override
  WordStudyState createState() => new WordStudyState(quizInstance, currentWord);
}

class WordStudyState extends State<QuizScreen> with TickerProviderStateMixin {
  final int currentWord;
  final QuizInstance quizInstance;
  QuizWord _quizWord;

  final List<OptionWidget> _options = <OptionWidget>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  WordStudyState(this.quizInstance, this.currentWord);

  @override
  void initState() {
    super.initState();
    setState(() {
      _quizWord = quizInstance.getQuizWord(currentWord);
    });
  }

  bool _solutionFound() {
    return _quizWord.options.where((o) => o.isCorrect && o.isSelected).length > 0;
  }

  void _handleWordTapped(int wordIndex) {


    if (!_solutionFound() && _quizWord.options[wordIndex].isEnabled) {
      setState(() {
        _quizWord.options[wordIndex].isSelected = true;
      });
    }
  }

  void _goToNext() {
    Navigator.of(context).push(new PageRouteBuilder(
      opaque: true,
      // 2
      transitionDuration: const Duration(milliseconds: 400),
      // 3
      pageBuilder: (BuildContext context, _, __) {
        return new QuizScreen(
            quizInstance: quizInstance,
            currentWord: currentWord + 1);
      },
      // 4
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return new SlideTransition(
          position: Tween<Offset>(
            begin: new Offset(1.0, 0.0),
            end: new Offset(0.0, 0.0),
          ).animate(
              new CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
              )
          ),
          child: child,
        );
      }
    ));
  }

  void _goToPrev() {
    Navigator.of(context).pop();
  }

  VoidCallback _getPreviousCallback() {
    if (currentWord > 0) {
      return () {
        _goToPrev();
      };
    }
    return null;
  }

  VoidCallback _getNextCallback() {
    if (!_solutionFound()) {
      return null;
    }

    int wordsCount = quizInstance.quiz.settings.wordsCount;

    if (currentWord < wordsCount - 1) {
      return () {
        _goToNext();
      };
    }
    else {
      return () {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (context) => new ResultsScreen()
            )
        );
      };
    }
  }

  Future<bool> _closeWarning() async {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(WordStudyLocalizations.of(context).exitQuiz),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(WordStudyLocalizations.of(context).exitQuizWarning),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(WordStudyLocalizations.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(WordStudyLocalizations.of(context).exit),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(builder: (BuildContext context) => new HomeScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
    return new Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    if (currentWord > 0) {
      return _buildScreen(context);
    }
    else {
      return new WillPopScope(
        onWillPop: _closeWarning,
        child:_buildScreen(context)
      );
    }
  }

  Widget _buildScreen(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          WordStudyLocalizations.of(context).questionNumber(
              currentWord + 1, quizInstance.quiz.settings.wordsCount)
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () async {
              await _closeWarning();
            },
          )
        ]
      ),
      body: new Stack(
        children: <Widget>[new ListView.builder(
          itemCount: (_quizWord.options.length + 1) * 2,
          itemBuilder: (BuildContext context, int position) {
            if (position.isEven && position > 0) return new Divider();

            final int index = (position + 1) ~/ 2;

            return _buildRow(index);
          }),
          new Align(
            alignment: new Alignment(0.0, 1.0),
            child: new Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new Row(
                    children: <Widget>[
                      new FlatButton(
                          onPressed: _getPreviousCallback(),
                          child: new Text(WordStudyLocalizations.of(context).previous)),
                      new Expanded( child:  new Text("")),
                      new FlatButton(
                          onPressed: _getNextCallback(),
                          child: new Text(WordStudyLocalizations.of(context).next))
                    ],
                  )
                )
              )
          )]
      ),
    );
  }

  Widget _buildRow(int i) {

    if (i == 0) {
      return new Container(
        decoration: new BoxDecoration(color: Colors.black12),
        child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Center(
                child: new Text(_quizWord.word, style: _biggerFont)
            )
        ),
    );
    }

    int optionIndex = i - 1;

    if (optionIndex >= _quizWord.options.length) {
      // Empty container for scrolling under bottom buttons
      return new Container(
        child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Center(
                child: new Text('')
            )
        ),
      );
    }

    OptionWidget option = new OptionWidget(
        quizOption: _quizWord.options[optionIndex],
        optionIndex: optionIndex,
        onTap: _handleWordTapped,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 200),
          vsync: this,
        ));

    if (_quizWord.options[optionIndex].isSelected && _quizWord.options[optionIndex].isEnabled) {
      option.animationController
          .addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed)
          _quizWord.options[optionIndex].isEnabled = false;
      });
      option.animationController.forward();
    }

    _options.add(option);

    return option;
  }

  @override
  void dispose() {
    for (OptionWidget word in _options) {
      word.animationController.dispose();
    }
    super.dispose();
  }
}

