import 'package:flutter/material.dart';
import 'package:word_study/models/quiz_option.dart';

typedef void OptionTapped(int index);

class OptionWidget extends StatelessWidget {
  final QuizOption quizOption;
  final OptionTapped onTap;
  final AnimationController animationController;
  final int optionIndex;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _biggerInvisibleFont = const TextStyle(fontSize: 18.0, color: Colors.transparent);

  OptionWidget({this.quizOption, this.onTap, this.optionIndex, this.animationController});

  Color _getColor() {
    if (quizOption.isSelected && quizOption.isCorrect) {
      return Colors.greenAccent;
    }
    else if (quizOption.isSelected && !quizOption.isCorrect) {
      return Colors.redAccent;
    }
    return Colors.transparent;
  }

  Widget _buildEnabled() {
    return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new GestureDetector(
          child: new Stack(
            children: [
              new SizeTransition(
                  sizeFactor: new CurvedAnimation(
                      parent: animationController, curve: Curves.easeOut),
                  axis: Axis.vertical,
                  axisAlignment: 0.0,
                  child: new Container(
                    decoration: new BoxDecoration(color: _getColor()),
                    child: new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Center(
                            child: new Text(quizOption.meaning, style: _biggerInvisibleFont)
                        )
                    ),
                  )
              ),
              new Row(
                  children: [new Expanded (
                      child: new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Container(
                        //decoration: new BoxDecoration(color: Colors.yellow),
                          child: new Text(quizOption.meaning, style: _biggerFont)
                      )
                ))]
              )
            ]
          ),
          onTap: () {
            onTap(optionIndex);
          }
        )
    );
  }

  Widget _buildDisabled() {
    return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Stack(
            children: [
              new Container(
                decoration: new BoxDecoration(color: _getColor()),
                child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Text(quizOption.meaning, style: _biggerInvisibleFont)
                    )
                ),
              ),
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(quizOption.meaning, style: _biggerFont)
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (quizOption.isEnabled) {
      return _buildEnabled();
    }
    else {
      return _buildDisabled();
    }
  }
}