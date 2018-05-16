import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/screens/files_list_screen.dart';

typedef OnSaveOrUpdateCallback = Function(Quiz quiz);
typedef QuizExists = bool Function(String name);
typedef GetTotalWordsCount = int Function();

class QuizSettingsForm extends StatefulWidget {
  final OnSaveOrUpdateCallback onSaveOrUpdate;
  final QuizExists quizExists;
  final List<String> files;
  final GetTotalWordsCount getTotalWordsCount;
  final int totalWordsCount;
  final String name;
  final Quiz quiz;

  QuizSettingsForm({@required this.onSaveOrUpdate, @required this.quizExists,
    this.files, this.name, this.getTotalWordsCount, this.totalWordsCount, this.quiz});

  @override State createState() => new QuizSettingsScreenState(onSaveOrUpdate: onSaveOrUpdate,
      quizExists: quizExists, files: files, name: name, getTotalWordsCount: getTotalWordsCount,
      quiz: quiz);
}

class QuizSettingsScreenState extends State<QuizSettingsForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final OnSaveOrUpdateCallback onSaveOrUpdate;
  final QuizExists quizExists;
  final GetTotalWordsCount getTotalWordsCount;
  final List<String> files;
  final String name;
  final Quiz quiz;

  QuizSettingsScreenState({@required this.onSaveOrUpdate, @required this.quizExists,
                      this.files, this.name, this.getTotalWordsCount, this.quiz});

  String _filesList;
  String _name;
  int _wordsCount;
  int _optionsCount;
  int _totalWordsCount;
  bool _inverse;

  TextEditingController _wordEditingController;

  @override void initState() {
    super.initState();

    if (quiz != null) {
      setState(() {

        print('Id: ${quiz.id}, words count: ${quiz.settings.wordsCount}');

        _inverse = quiz.settings.inverse;
        _filesList = quiz.filenames.join(',');
        _name = quiz.name;
        _wordsCount = quiz.settings.wordsCount;
        _optionsCount = quiz.settings.optionsCount;
        _totalWordsCount = getTotalWordsCount();
        _wordEditingController =
          new TextEditingController(text: '${quiz.settings.wordsCount}');
      });
    }
    else {

      print('Quiz is null');

      setState(() {
        _inverse = false;
        _filesList = files.join(',');
        _totalWordsCount = getTotalWordsCount();
        _wordEditingController =
          new TextEditingController(text: '$_totalWordsCount');
      });
    }
  }

  @override
  void didUpdateWidget(QuizSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.totalWordsCount != getTotalWordsCount()) {
      setState(() {

        print('Update');

        _totalWordsCount = getTotalWordsCount();
        _wordEditingController =
          new TextEditingController(text: '$_totalWordsCount');
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
              var v = int.tryParse(value) ?? 0;
              if (v < 1) {
                return WordStudyLocalizations.of(context).pleaseEnterANumberGreaterThan0;
              }
              if (v > _totalWordsCount) {
                return WordStudyLocalizations.of(context).pleaseEnterANumberLessThan(_totalWordsCount);
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
            initialValue: this.quiz == null ? '4' : '${this.quiz.settings.optionsCount}',
            decoration: new InputDecoration(
              labelText: WordStudyLocalizations.of(context).optionsCount,
              hintText: WordStudyLocalizations.of(context).optionsCount,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return WordStudyLocalizations.of(context).pleaseEnterANumber;
              }
              var v = int.tryParse(value) ?? 0;
              if (v < 1) {
                return WordStudyLocalizations.of(context).pleaseEnterANumberGreaterThan0;
              }
              if (v > _totalWordsCount) {
                return WordStudyLocalizations.of(context).pleaseEnterANumberLessThan(_totalWordsCount);
              }
            },
            onSaved: (value) {
              var v = int.parse(value);
              _optionsCount = v;
            },
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.cached),
          title: new Text(WordStudyLocalizations.of(context).inverse),
          trailing: new Checkbox(
              value: _inverse,
              onChanged: (value) => setState(() {_inverse = value;})
          ),
        ),
        const Divider(
          height: 1.0,
        ),
        new Container(
          width: screenSize.width - 20.0,
          child: new RaisedButton(
            child: new Text(
                quiz == null ?
                    WordStudyLocalizations.of(context).create :
                    WordStudyLocalizations.of(context).edit
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
                  if (quiz == null && quizExists(_name)) {
                    Scaffold.of(context).showSnackBar(
                        new SnackBar(
                            content: new Text(
                                WordStudyLocalizations.of(context).aQuizWithThisNameAlreadyExists),
                            backgroundColor: Colors
                                .redAccent));
                  }
                  else {
                    Quiz quiz = new Quiz(
                        id: this.quiz == null ? -1: this.quiz.id,
                        name: _name,
                        filenames: files,
                        settings: new QuizSettings(wordsCount: _wordsCount,
                            optionsCount: _optionsCount,
                            inverse: _inverse));
                    onSaveOrUpdate(quiz);
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

