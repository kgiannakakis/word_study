import 'package:flutter/material.dart';

class QuizSettingsWidget extends StatelessWidget {

  final List<String> files;

  QuizSettingsWidget(this.files);

  void _create() {

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quiz Settings'),
      ),
      body: new Column(children: <Widget>[
        new Text(files[0]),
        new Text('Word Count'),
        new Text('Options Count')
      ],),
      floatingActionButton: new FloatingActionButton(onPressed: _create,
          child: new Icon(Icons.add)),
    );
  }
}

