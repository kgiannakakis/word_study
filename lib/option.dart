import 'package:flutter/material.dart';
import 'package:word_study/words/quizoption.dart';

typedef void OptionTapped(int index);

class Option extends StatelessWidget {
  final QuizOption quizOption;
  final OptionTapped onTap;
  final AnimationController animationController;
  final int optionIndex;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _biggerInvisibleFont = const TextStyle(fontSize: 18.0, color: Colors.transparent);

  Option({this.quizOption, this.onTap, this.optionIndex, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Stack(
            children: [
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new SizeTransition(
                        sizeFactor: new CurvedAnimation(
                            parent: animationController, curve: Curves.easeOut),
                        axis: Axis.vertical,
                        axisAlignment: 0.0,
                        child: new Container(
                            decoration: new BoxDecoration(color:
                                quizOption.isSelected ? Colors.red : Colors.yellow),
                            child: new Center(
                              child: new Text(quizOption.meaning, style: _biggerInvisibleFont)
                            ),
                        )
                    ),
                  )
                ],
              ),
              new GestureDetector(
                child: new Text(quizOption.meaning, style: _biggerFont),
                onTap: () {
                  onTap(optionIndex);
                })
              ]
        )
    );
  }
}