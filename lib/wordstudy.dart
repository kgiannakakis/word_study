import 'package:flutter/material.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/quizword.dart';

class WordStudy extends StatefulWidget {
  @override
  WordStudyState createState() => new WordStudyState();
}

class WordStudyState extends State<WordStudy> {
  QuizWord _quizWord;

  final WordProvider wordProvider = new WordProvider();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    setState(() {
      _quizWord = wordProvider.getWord(4);
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
    return

    new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Stack(
          children: [
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                      constraints: new BoxConstraints.expand(
                          height: 60.0),
                      decoration: new BoxDecoration(color:
                      _quizWord.options[i].isSelected ? Colors.red : Colors.transparent)
                  ),
                )
              ],
            ),
            new ListTile(title: new Text("${_quizWord.options[i].meaning}", style: _biggerFont),
              onTap: () {
                setState(() {
                  _quizWord.options[i].isSelected = true;
                });
              }
          )]
        )
    );

  }
}
