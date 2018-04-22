import 'package:flutter/material.dart';
import 'package:word_study/fileslist.dart';
import 'package:word_study/words/quizsettings.dart';
import 'package:word_study/words/quiz.dart';
import 'package:word_study/words/quizprovider.dart';

class QuizSettingsWidget extends StatefulWidget {

  QuizSettingsWidget();

  @override
  QuizSettingsWidgetState createState() => new QuizSettingsWidgetState();
}

class QuizSettingsWidgetState extends State<QuizSettingsWidget> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<String> _files = [];
  int _totalWordsCount = 0;
  QuizSettings _quizSettings = new QuizSettings();
  String _name;

  final QuizProvider _quizProvider = new QuizProvider();

  QuizSettingsWidgetState();

//  String _getWordCountValue() {
//    if (_quizSettings.wordsCount != null) {
//      return '${_quizSettings.wordsCount}';
//    }
//    if (_totalWordsCount > 0) {
//      return '$_totalWordsCount';
//    }
//    return '';
//  }
//
//  String _getNameValue() {
//    if (_name != null) {
//      return _name;
//    }
//    return _files.length > 0 ? _files[0] : null;
//  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quiz Settings'),
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return new SingleChildScrollView (
            child: new Form(
              key: _formKey,
              child: new Column(children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.archive),
                  title: new FocusScope(
                    node: new FocusScopeNode(),
                    child: new TextFormField(
                      keyboardType: TextInputType.text,
                      controller: new TextEditingController(text: _files.length > 0 ? _files[0] : null),
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
                      List<dynamic> filesResult = await Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (context) => new FilesList()
                          )
                      );
                      if (filesResult != null) {
                        setState(() {
                          _files = filesResult[0] as List<String>;
                          print(_files);
                          _totalWordsCount = filesResult[1] as int;
                          print(_totalWordsCount);
                        });
                      }
                    },
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.assignment),
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    //controller: new TextEditingController(text: _getNameValue()),
                    decoration: new InputDecoration(
                      labelText: "Name",
                      hintText: "Name",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the name of the quiz';
                      }
                    },
                    onFieldSubmitted: (value) => _name = value,
                    onSaved: (value) => _name = value,
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.apps),
                  title: new TextFormField(
                    keyboardType: TextInputType.number,
                    //controller: new TextEditingController(text: _getWordCountValue()),
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
                    onFieldSubmitted: (value) => _quizSettings.wordsCount = int.parse(value, onError: (source) => 0),
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
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        if (_quizSettings.optionsCount > _quizSettings.wordsCount) {
                          Scaffold.of(context).showSnackBar(
                              new SnackBar(
                                  content: new Text('Options count must be less than words count'),
                                  backgroundColor: Colors.redAccent));
                        }
                        else {
                          await _quizProvider.init();
                          if (_quizProvider.quizExists(_name)) {
                            Scaffold.of(context).showSnackBar(
                                new SnackBar(
                                    content: new Text(
                                        'A quiz with this name already exists!'),
                                    backgroundColor: Colors.redAccent));
                          }
                          else {
                            Quiz quiz = new Quiz(name: _name, filenames: _files, settings: _quizSettings);
                            bool added = await _quizProvider.addQuiz(quiz);
                            if (added) {
                              Navigator.of(context).pop();
                            }
                            else {
                              Scaffold.of(context).showSnackBar(
                                  new SnackBar(
                                      content: new Text(
                                          'Failed to add quiz!'),
                                      backgroundColor: Colors.redAccent));
                            }
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

