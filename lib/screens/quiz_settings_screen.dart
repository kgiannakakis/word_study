import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:word_study/models/appstate.dart';
import 'package:word_study/screens/files_list_screen.dart';
import 'package:word_study/models/quizsettings.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/words/quizprovider.dart';

class QuizSettingsScreen extends StatelessWidget {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> _nameKey =
    new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _wordsCountKey =
    new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _optionsCountKey =
    new GlobalKey<FormFieldState<String>>();

  final QuizProvider _quizProvider = new QuizProvider();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return
      new StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Quiz Settings'),
            ),
            body: new Builder(
              builder: (BuildContext context) {

                String filenames = vm.files.join(',');
                String name = vm.name;

                print('------');
                print('$filenames ${vm.totalWordsCount} ${vm.name}');
                print('------');

                return new SingleChildScrollView (
                  child: new Form(
                    key: _formKey,
                    child: new Column(children: <Widget>[
                      new ListTile(
                        //key: _filesKey,
                        leading: const Icon(Icons.archive),
                        title: new FocusScope(
                          node: new FocusScopeNode(),
                          child: new TextFormField(
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
                        key: _nameKey,
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
                        ),
                      ),
                      new ListTile(
                        key: _wordsCountKey,
                        leading: const Icon(Icons.apps),
                        title: new TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: '${vm.totalWordsCount}',
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
                            if (v > vm.totalWordsCount) {
                              return 'Please enter a number less than ${vm.totalWordsCount}';
                            }
                          },
                        ),
                      ),
                      new ListTile(
                        key: _optionsCountKey,
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
                            if (v > vm.totalWordsCount) {
                              return 'Please enter a number less than ${vm.totalWordsCount}';
                            }
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
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              int optionsCount = int.parse(_optionsCountKey.currentState.value);
                              int wordsCount = int.parse(_wordsCountKey.currentState.value);
                              String name = _nameKey.currentState.value;

                              if (optionsCount > wordsCount) {
                                Scaffold.of(context).showSnackBar(
                                    new SnackBar(
                                        content: new Text(
                                            'Options count must be less than words count'),
                                        backgroundColor: Colors
                                            .redAccent));
                              }
                              else {
                                await _quizProvider.init();
                                if (_quizProvider.quizExists(name)) {
                                  Scaffold.of(context).showSnackBar(
                                      new SnackBar(
                                          content: new Text(
                                              'A quiz with this name already exists!'),
                                          backgroundColor: Colors
                                              .redAccent));
                                }
                                else {
                                  Quiz quiz = new Quiz(name: name,
                                      filenames: vm.files,
                                      settings: new QuizSettings(wordsCount: wordsCount,
                                                                 optionsCount: optionsCount));
                                  bool added = await _quizProvider
                                      .addQuiz(quiz);
                                  if (added) {
                                    Navigator.of(context).pop();
                                  }
                                  else {
                                    Scaffold.of(context).showSnackBar(
                                        new SnackBar(
                                            content: new Text(
                                                'Failed to add quiz!'),
                                            backgroundColor: Colors
                                                .redAccent));
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
    );
  }
}

class _ViewModel {
  final List<String> files;
  final int totalWordsCount;
  final String name;

  _ViewModel({
    @required this.files,
    @required this.totalWordsCount,
    @required this.name,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      files: store.state.selectedFiles,
      name: store.state.selectedFiles.length > 0 ? store.state.selectedFiles[0] : '',
      totalWordsCount: store.state.totalWordsCount
    );
  }
}

