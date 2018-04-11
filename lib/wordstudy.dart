import 'package:flutter/material.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/quizword.dart';
import 'package:word_study/option.dart';

class WordStudy extends StatefulWidget {

  final WordProvider wordProvider;

  WordStudy({this.wordProvider});

  @override
  WordStudyState createState() => new WordStudyState(wordProvider);
}

class WordStudyState extends State<WordStudy> with TickerProviderStateMixin {
  final WordProvider wordProvider;
  final List<Option> _words = <Option>[];
  QuizWord _quizWord;

  WordStudyState(this.wordProvider);

  @override
  void initState() {
    super.initState();
    setState(() {
      _quizWord = wordProvider.getWord(4);
    });
  }

  void _handleWordTapped(int wordIndex) {
    if (_quizWord.options[wordIndex].isEnabled) {
      setState(() {
        _quizWord.options[wordIndex].isSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text(_quizWord.word),
      ),
      body: new ListView.builder(
          itemCount: _quizWord.options.length * 2,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return new Divider();

            final index = position ~/ 2;

            return _buildRow(index);
          }),
    );
  }

  Widget _buildRow(int i) {
    Option wordDisplay =  new Option(
        quizOption: _quizWord.options[i],
        optionIndex: i,
        onTap: _handleWordTapped,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 200),
          vsync: this,
        )
    );

    if (_quizWord.options[i].isSelected && _quizWord.options[i].isEnabled) {
      wordDisplay.animationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed)
          _quizWord.options[i].isEnabled = false;
      });
      wordDisplay.animationController.forward();
    }

    return wordDisplay;
  }

  @override
  void dispose() {
    for(Option word in _words) {
      word.animationController.dispose();
    }
    super.dispose();
  }
}
