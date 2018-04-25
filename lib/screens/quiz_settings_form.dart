import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/screens/files_list_screen.dart';

typedef OnSaveCallback = Function(Quiz quiz);
typedef QuizExists = bool Function(String name);

class QuizSettingsForm extends StatefulWidget {
  final OnSaveCallback onSave;
  final QuizExists quizExists;
  final List<String> files;
  final int totalWordsCount;
  final String name;

  QuizSettingsForm({@required this.onSave, @required this.quizExists,
    this.files, this.name, this.totalWordsCount}) {
  }

  @override State createState() => new QuizSettingsScreenState(onSave: onSave,
      quizExists: quizExists, files: files, name: name, totalWordsCount: totalWordsCount);
}

class QuizSettingsScreenState extends State<QuizSettingsForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final OnSaveCallback onSave;
  final QuizExists quizExists;
  final List<String> files;
  final String name;
  final int totalWordsCount;

  QuizSettingsScreenState({@required this.onSave, @required this.quizExists,
                      this.files, this.name, this.totalWordsCount}) {
  }

  String _filesList;
  String _name;
  int _wordsCount;
  int _optionsCount;

  @override void initState() {
    super.initState();

    setState(() {
      _filesList = files.join(',');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Form(
      key: _formKey,
      child: new Column(children: <Widget>[
        new ListTile(
          leading: const Icon(Icons.archive),
          title: new FocusScope(
            node: new FocusScopeNode(),
            child: new TextFormField(
              keyboardType: TextInputType.text,
              initialValue: _filesList,
              decoration: new InputDecoration(
                hintText: 'Files',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select a file';
                }
              },
            ),
          ),
          trailing: new FlatButton(
            child: new Icon(Icons.arrow_drop_down_circle),
            onPressed: () async {
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context) => new FilesListScreen()
                  )
              );
            },
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.assignment),
          title: new TextFormField(
            keyboardType: TextInputType.text,
            initialValue: name,
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
            initialValue: '$totalWordsCount',
            decoration: new InputDecoration(
              labelText: "Word Count",
              hintText: "Word Count",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a number';
              }
              var v = int.parse(
                  value, onError: (source) => 0);
              if (v < 1) {
                return 'Please enter a number greater than 0';
              }
              if (v > totalWordsCount) {
                return 'Please enter a number less than $totalWordsCount';
              }
            },
            onSaved: (value) {
              var v = int.parse(value);
              _wordsCount = v;
            },
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
              var v = int.parse(
                  value, onError: (source) => 0);
              if (v < 1) {
                return 'Please enter a number greater than 0';
              }
              if (v > totalWordsCount) {
                return 'Please enter a number less than $totalWordsCount';
              }
            },
            onSaved: (value) {
              var v = int.parse(value);
              _optionsCount = v;
            },
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

                if (_optionsCount > _wordsCount) {
                  Scaffold.of(context).showSnackBar(
                      new SnackBar(
                          content: new Text(
                              'Options count must be less than words count'),
                          backgroundColor: Colors
                              .redAccent));
                }
                else {
                  if (quizExists(_name)) {
                    Scaffold.of(context).showSnackBar(
                        new SnackBar(
                            content: new Text(
                                'A quiz with this name already exists!'),
                            backgroundColor: Colors
                                .redAccent));
                  }
                  else {
                    Quiz quiz = new Quiz(name: _name,
                        filenames: files,
                        settings: new QuizSettings(wordsCount: _wordsCount,
                            optionsCount: _optionsCount));
                    onSave(quiz);
                    Navigator.of(context).pop();
                  }
                }
              }
            },
          ),
          margin: new EdgeInsets.only(
              top: 20.0, bottom: 20.0
          ),
        )
      ],),
    );
  }
}

