import 'dart:async';

import 'package:flutter/material.dart';
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

  WordStudyState(this.quizInstance, this.currentWord);

  @override
  void initState() {
    super.initState();
    setState(() {
      _quizWord = quizInstance.getQuizWord(currentWord);
    });
  }

  void _handleWordTapped(int wordIndex) {
    if (_quizWord.options[wordIndex].isEnabled) {
      setState(() {
        _quizWord.options[wordIndex].isSelected = true;
      });
    }
  }

  VoidCallback _getPreviousCallback() {
    if (currentWord > 0) {
      return () {
        Navigator.of(context).pop();
      };
    }
    return null;
  }

  VoidCallback _getNextCallback() {
    int wordsCount = quizInstance.quiz.settings.wordsCount;

    if (currentWord < wordsCount - 1) {
      return () {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (context) => new QuizScreen(quizInstance: quizInstance,
                  currentWord: currentWord + 1)
            )
        );
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
          title: new Text('Exit quiz'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Are you sure you want to exit the quiz?'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Exit'),
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
        title: new Text(_quizWord.word), 
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
          itemCount: _quizWord.options.length * 2,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return new Divider();

            final index = position ~/ 2;

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
                      new FlatButton(onPressed: _getPreviousCallback(), child: new Text("Previous")),
                      new Expanded( child:  new Text("")),
                      new FlatButton(onPressed: _getNextCallback(), child: new Text("Next"))
                    ],
                  )
                )
              )
          )]
      ),
    );
  }

  Widget _buildRow(int i) {
    OptionWidget option = new OptionWidget(
        quizOption: _quizWord.options[i],
        optionIndex: i,
        onTap: _handleWordTapped,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 200),
          vsync: this,
        ));

    if (_quizWord.options[i].isSelected && _quizWord.options[i].isEnabled) {
      option.animationController
          .addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed)
          _quizWord.options[i].isEnabled = false;
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
