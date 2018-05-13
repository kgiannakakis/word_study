import 'package:flutter/material.dart';
import 'package:word_study/models/quiz_option.dart';
import 'package:word_study/screens/list_item_text_style.dart';

typedef void OptionTapped(int index);

class OptionWidget extends StatelessWidget {
  final QuizOption quizOption;
  final OptionTapped onTap;
  final AnimationController animationController;
  final int optionIndex;

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

  Widget _buildEnabled(BuildContext context) {
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
                            child: new Text(quizOption.meaning,
                                style: ListItemTextStyle.display5(context).copyWith(color: Colors.transparent)
                            )
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
                          child: new Text(quizOption.meaning,
                              style: ListItemTextStyle.display5(context))
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

  Widget _buildDisabled(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Stack(
            children: [
              new Container(
                decoration: new BoxDecoration(color: _getColor()),
                child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Text(quizOption.meaning,
                          style: ListItemTextStyle.display5(context).copyWith(color: Colors.transparent))
                    )
                ),
              ),
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(quizOption.meaning,
                      style: ListItemTextStyle.display5(context))
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (quizOption.isEnabled) {
      return _buildEnabled(context);
    }
    else {
      return _buildDisabled(context);
    }
  }
}