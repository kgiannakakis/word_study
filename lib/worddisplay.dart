import 'package:flutter/material.dart';

typedef void WordTapped(int index);

class WordDisplay extends StatelessWidget {
  final AnimationController animationController;
  final String meaning;
  final bool isCorrect;
  final bool isSelected;
  final int wordIndex;
  final WordTapped wordTapped;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  WordDisplay(this.meaning, this.isCorrect, this.isSelected,
              this.wordIndex, this.wordTapped,
              this.animationController) {

  }

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
                            isSelected ? Colors.red : Colors.yellow)
                        )
                    ),
                  )
                ],
              ),
              new ListTile(title: new Text("${meaning}", style: _biggerFont),
                  onTap: () {
                    wordTapped(wordIndex);
                  }
              )]
        )
    );
  }
}