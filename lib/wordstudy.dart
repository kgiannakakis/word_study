import 'package:flutter/material.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/quizword.dart';
import 'package:word_study/option.dart';

class WordStudy extends StatefulWidget {
  final WordProvider wordProvider;
  final int currentWord;
  final int wordsCount;

  WordStudy({this.wordProvider, this.currentWord, this.wordsCount});

  @override
  WordStudyState createState() => new WordStudyState(wordProvider, currentWord, wordsCount);
}

class WordStudyState extends State<WordStudy> with TickerProviderStateMixin {
  final WordProvider wordProvider;
  final int currentWord;
  final int wordsCount;
  int optionsCount = 4;

  final List<Option> _options = <Option>[];
  QuizWord _quizWord = new QuizWord("", []);

  WordStudyState(this.wordProvider, this.currentWord, this.wordsCount);

  @override
  void initState() {
    super.initState();
    if (currentWord == 0) {
      _loadState();
    }
    else {
      setState(() {
        _quizWord = wordProvider.getWord(optionsCount);
      });
    }
  }

  void _loadState() async {
    bool ok = await wordProvider.init();
    if (ok) {
      setState(() {
        _quizWord = wordProvider.getWord(optionsCount);
      });
    }
    else {
      print("Init failed");
    }
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
    if (currentWord < wordsCount - 1) {
      return () {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (context) => new WordStudy(wordProvider: wordProvider,
                  currentWord: currentWord + 1,
                  wordsCount: wordsCount,)
            )
        );
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_quizWord.word),
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
    Option option = new Option(
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
    for (Option word in _options) {
      word.animationController.dispose();
    }
    super.dispose();
  }
}
