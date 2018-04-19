import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:word_study/words/quizsettings.dart';
import 'package:word_study/words/quiz.dart';
import 'package:word_study/files/fileservice.dart';

class QuizSettingsWidget extends StatefulWidget {

  final List<String> files;
  final int totalWordsCount;

  QuizSettingsWidget(this.files, this.totalWordsCount);

  @override
  QuizSettingsWidgetState createState() => new QuizSettingsWidgetState(files, totalWordsCount);
}

class QuizSettingsWidgetState extends State<QuizSettingsWidget> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final List<String> files;
  final int totalWordsCount;

  QuizSettings _quizSettings = new QuizSettings();
  String _name;

  final FileService _fileService = new FileService();

  QuizSettingsWidgetState(this.files, this.totalWordsCount);

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
                leading: const Icon(Icons.assignment),
                title: new TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: files[0],
                  decoration: new InputDecoration(
                    labelText: "Name",
                    hintText: "Name",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the name of the quiz';
                    }
                  },
                  onSaved: (value) => _name = value,
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.apps),
                title: new TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: totalWordsCount > 0 ? '$totalWordsCount' : '',
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
                    if (v > totalWordsCount) {
                      return 'Please enter a number less than $totalWordsCount';
                    }
                  },
                  onSaved: (value) => _quizSettings.wordsCount = int.parse(value, onError: (source) => 0),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.grain),
                title: new TextFormField(
                  keyboardType: TextInputType.number,
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
                    if (v > totalWordsCount) {
                      return 'Please enter a number less than $totalWordsCount';
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
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (_quizSettings.optionsCount > _quizSettings.wordsCount) {
                        Scaffold.of(context).showSnackBar(
                            new SnackBar(
                                content: new Text('Options count must be less than words count'),
                                backgroundColor: Colors.red));
                      }
                      else {
                        String path = await _fileService.localPath;
                        File file = new File('$path/$_name');

                        if (await file.exists()) {
                          Scaffold.of(context).showSnackBar(
                              new SnackBar(
                                  content: new Text(
                                      'A quiz with this name already exists!'),
                                  backgroundColor: Colors.red));
                        }
                        else {
                          Quiz quiz = new Quiz(name: _name, filenames: files, settings: _quizSettings);

                          String quizJson = json.encode(quiz);

                          print(quizJson);

                          Quiz q = Quiz.fromJson(json.decode(quizJson));

                          print(q.name);
                          print(q.settings.toJson());
                          print(q.filenames);
                          
                        }
                      }
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

