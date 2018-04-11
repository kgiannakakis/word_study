import 'package:flutter/material.dart';
import 'package:word_study/words/quizoption.dart';

typedef void WordTapped(int index);

class WordDisplay extends StatelessWidget {
  final QuizOption quizOption;
  final  WordTapped onTap;
  final AnimationController animationController;
  final int optionIndex;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  WordDisplay({this.quizOption, this.onTap, this.optionIndex, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Stack(
            children: [
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new SizeTransition(
                        sizeFactor: new CurvedAnimation(
                            parent: animationController, curve: Curves.easeOut),
                        axisAlignment: 0.0,
                        child: new Container(
                            constraints: new BoxConstraints.expand(
                                height: 60.0),
                            decoration: new BoxDecoration(color:
                            quizOption.isSelected ? Colors.red : Colors.yellow)
                        )
                    ),
                  )
                ],
              ),
              new ListTile(title: new Text(quizOption.meaning, style: _biggerFont),
                  onTap: () {
                    onTap(optionIndex);
                  }
              )]
        )
    );
  }
}