import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/screens/files_list_screen.dart';
import 'package:word_study/localizations.dart';

typedef OnSaveCallback = Function(Quiz quiz);
typedef QuizExists = bool Function(String name);
typedef GetTotalWordsCount = int Function();

class QuizSettingsForm extends StatefulWidget {
  final OnSaveCallback onSave;
  final QuizExists quizExists;
  final List<String> files;
  final GetTotalWordsCount getTotalWordsCount;
  final int totalWordsCount;
  final String name;

  QuizSettingsForm({@required this.onSave, @required this.quizExists,
    this.files, this.name, this.getTotalWordsCount, this.totalWordsCount});

  @override State createState() => new QuizSettingsScreenState(onSave: onSave,
      quizExists: quizExists, files: files, name: name, getTotalWordsCount: getTotalWordsCount);
}

class QuizSettingsScreenState extends State<QuizSettingsForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final OnSaveCallback onSave;
  final QuizExists quizExists;
  final GetTotalWordsCount getTotalWordsCount;
  final List<String> files;
  final String name;

  QuizSettingsScreenState({@required this.onSave, @required this.quizExists,
                      this.files, this.name, this.getTotalWordsCount});

  String _filesList;
  String _name;
  int _wordsCount;
  int _optionsCount;
  int totalWordsCount;

  TextEditingController _wordEditingController;

  @override void initState() {
    super.initState();

    setState(() {
      _filesList = files.join(',');
      totalWordsCount = getTotalWordsCount();
      _wordEditingController = new TextEditingController(text: '$totalWordsCount');
    });
  }

  @override
  void didUpdateWidget(QuizSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.totalWordsCount != getTotalWordsCount()) {
      setState(() {
        totalWordsCount = getTotalWordsCount();
        _wordEditingController =
        new TextEditingController(text: '$totalWordsCount');
      });
    }
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
                hintText: WordStudyLocalizations.of(context).files,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return WordStudyLocalizations.of(context).pleaseSelectAFile;
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
              labelText: WordStudyLocalizations.of(context).name,
              hintText: WordStudyLocalizations.of(context).name,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return WordStudyLocalizations.of(context).pleaseEnterTheNameOfTheQuiz;
              }
            },
            onSaved: (value) => _name = value,
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.apps),
          title: new TextFormField(
            keyboardType: TextInputType.number,
            controller: _wordEditingController,
            decoration: new InputDecoration(
              labelText: WordStudyLocalizations.of(context).wordsCount,
              hintText: WordStudyLocalizations.of(context).wordsCount,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return WordStudyLocalizations.of(context).pleaseEnterANumber;
              }
              var v = int.parse(
                  value, onError: (source) => 0);
              if (v < 1) {
                return WordStudyLocalizations.of(context).pleaseEnterANumberGreaterThan0;
              }
              if (v > totalWordsCount) {
                return WordStudyLocalizations.of(context).pleaseEnterANumberLessThan(totalWordsCount);
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
              labelText: WordStudyLocalizations.of(context).optionsCount,
              hintText: WordStudyLocalizations.of(context).optionsCount,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return WordStudyLocalizations.of(context).pleaseEnterANumber;
              }
              var v = int.parse(
                  value, onError: (source) => 0);
              if (v < 1) {
                return WordStudyLocalizations.of(context).pleaseEnterANumberGreaterThan0;
              }
              if (v > totalWordsCount) {
                return WordStudyLocalizations.of(context).pleaseEnterANumberLessThan(totalWordsCount);
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
                WordStudyLocalizations.of(context).create
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                if (_optionsCount > _wordsCount) {
                  Scaffold.of(context).showSnackBar(
                      new SnackBar(
                          content: new Text(
                              WordStudyLocalizations.of(context).optionsCountMustBeLessThanWordsCount),
                          backgroundColor: Colors
                              .redAccent));
                }
                else {
                  if (quizExists(_name)) {
                    Scaffold.of(context).showSnackBar(
                        new SnackBar(
                            content: new Text(
                                WordStudyLocalizations.of(context).aQuizWithThisNameAlreadyExists),
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

