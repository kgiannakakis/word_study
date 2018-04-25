import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/screens/quiz_settings_form.dart';

class CreateQuiz extends StatelessWidget {
  CreateQuiz({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<AppState>(
      onInit: (store) {
        store.dispatch(new CalculateTotalWordsCountAction());
      },
      builder: (BuildContext context, Store<AppState> store) {
        _ViewModel vm = _ViewModel.fromStore(store);

        return new Scaffold(
            appBar: new AppBar(
              title: new Text('Quiz Settings'),
            ),
            body: new Builder(
                builder: (BuildContext context) {
                  return new SingleChildScrollView (
                      child: new QuizSettingsForm(
                        onSave: vm.onSave,
                        quizExists: vm.quizExists,
                        totalWordsCount: vm.totalWordsCount,
                        name: vm.name,
                        files: vm.files,
                      )
                  );
                }
            )
        );
      },
    );
  }
}

class _ViewModel {
  final List<String> files;
  final String name;
  final int totalWordsCount;
  final OnSaveCallback onSave;
  final QuizExists quizExists;

  _ViewModel({
    @required this.files,
    @required this.name,
    @required this.onSave,
    @required this.totalWordsCount,
    @required this.quizExists
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
        files: store.state.selectedFiles,
        name: store.state.selectedFiles.length > 0 ? store.state.selectedFiles[0] : '',
        onSave: (quiz) {
          store.dispatch(new AddQuizAction(quiz));
        },
        totalWordsCount: store.state.totalWordsCount,
        quizExists: (name) {
          return store.state.quizzes.where((q) => q.name == name).length > 0;
      }
    );
  }
}
