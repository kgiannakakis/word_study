import 'package:flutter/material.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/quizword.dart';
import 'package:word_study/worddisplay.dart';

class WordStudy extends StatefulWidget {
  @override
  WordStudyState createState() => new WordStudyState();
}

class WordStudyState extends State<WordStudy> with TickerProviderStateMixin {
  QuizWord _quizWord;

  final WordProvider wordProvider = new WordProvider();
  final List<WordDisplay> _words = <WordDisplay>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      _quizWord = wordProvider.getWord(4);
    });
  }

  void _handleWordTapped(int wordIndex) {
    setState(() {
      _quizWord.options[wordIndex].isSelected = true;
    });
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
    WordDisplay wordDisplay =  new WordDisplay(_quizWord.options[i].meaning,
        _quizWord.options[i].isCorrect, _quizWord.options[i].isSelected,
        i, _handleWordTapped,
        new AnimationController(
          duration: new Duration(milliseconds: 700),
          vsync: this,
        )
    );

    if (_quizWord.options[i].isSelected) {
      wordDisplay.animationController.forward();
    }

    return wordDisplay;
  }

  @override
  void dispose() {
    for(WordDisplay word in _words) {
      word.animationController.dispose();
    }
    super.dispose();
  }
}
