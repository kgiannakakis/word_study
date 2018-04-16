import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:word_study/words/quizsettings.dart';

class QuizSettingsWidget extends StatefulWidget {

  final List<String> files;

  QuizSettingsWidget(this.files);

  @override
  QuizSettingsWidgetState createState() => new QuizSettingsWidgetState(files);
}

class QuizSettingsWidgetState extends State<QuizSettingsWidget> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final List<String> files;

  QuizSettings _quizSettings = new QuizSettings();
  int _totalWordsCount = 10;

  QuizSettingsWidgetState(this.files);

  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quiz Settings'),
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return new Form(
            key: _formKey,
            child: new Column(children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.archive),
                title: new Text('Files'),
                subtitle: new Text(files[0]),
              ),
              new ListTile(
                leading: const Icon(Icons.apps),
                title: new TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: new InputDecoration(
                    labelText: "Word Count",
                    hintText: "Word Count",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a number';
                    }
                    var v = int.parse(value, onError: (source) => 0);
                    if (v < 1) {
                      return 'Please enter a number greater than 0';
                    }
                    if (v > _totalWordsCount) {
                      return 'Please enter a number less than $_totalWordsCount';
                    }
                  },
                  onSaved: (value) => _quizSettings.wordsCount = int.parse(value, onError: (source) => 0),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.grain),
                title: new TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  initialValue: '4',
                  decoration: new InputDecoration(
                    labelText: "Options Count",
                    hintText: "Options Count",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a number';
                    }
                    var v = int.parse(value, onError: (source) => 0);
                    if (v < 1) {
                      return 'Please enter a number greater than 0';
                    }
                    if (v > _totalWordsCount) {
                      return 'Please enter a number less than $_totalWordsCount';
                    }
                  },
                  onSaved: (value) => _quizSettings.optionsCount = int.parse(value, onError: (source) => 0),
                ),
              ),
              const Divider(
                height: 1.0,
              ),
              new Container(
                width: screenSize.width - 20.0,
                child: new RaisedButton(
                  child: new Text(
                    'Create'
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (_quizSettings.optionsCount > _quizSettings.wordsCount) {
                        Scaffold.of(context).showSnackBar(
                            new SnackBar(
                                content: new Text('Options count must be less than words count'),
                                backgroundColor: Colors.red));
                      }

                      print('${_quizSettings.wordsCount} ${_quizSettings.optionsCount}');
                    }
                  },
                ),
                margin: new EdgeInsets.only(
                    top: 20.0
                ),
              )
            ],),
          );
        }
        )
    );
  }
}

