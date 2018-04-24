import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:word_study/screens/files_list_screen.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/models/quiz.dart';

typedef OnSaveCallback = Function(Quiz quiz);
typedef QuizExists = bool Function(String name);

class QuizSettingsScreen extends StatelessWidget {

  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _filesKey =
    new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _nameKey =
    new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _wordsCountKey =
    new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _optionsCountKey =
    new GlobalKey<FormFieldState<String>>();

  final OnSaveCallback onSave;
  final QuizExists quizExists;
  final List<String> files;
  final int totalWordsCount;
  final String name;

  QuizSettingsScreen({@required this.onSave, @required this.quizExists,
                      this.files, this.totalWordsCount, this.name});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quiz Settings'),
      ),
      body: new Builder(
        builder: (BuildContext context) {

          String filenames = files.join(',');

          return new SingleChildScrollView (
            child: new Form(
              key: _formKey,
              child: new Column(children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.archive),
                  title: new FocusScope(
                    node: new FocusScopeNode(),
                    child: new TextFormField(
                      key: _filesKey,
                      keyboardType: TextInputType.text,
                      initialValue: filenames,
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
                    key: _nameKey,
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
                    //onSaved: (value) => _name = value,
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.apps),
                  title: new TextFormField(
                    key: _wordsCountKey,
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
                    //onSaved: (value) => _wordsCount = int.parse(value),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.grain),
                  title: new TextFormField(
                    key: _optionsCountKey,
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
                    //onSaved: (value) => _optionsCount = int.parse(value),
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

                        int optionsCount = int.parse(_optionsCountKey.currentState.value);
                        int wordsCount = int.parse(_wordsCountKey.currentState.value);
                        String _name = _nameKey.currentState?.value;

                        if (optionsCount > wordsCount) {
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
                                settings: new QuizSettings(wordsCount: wordsCount,
                                                           optionsCount: optionsCount));
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
            )
          );
        }
      )
    );
  }
}

