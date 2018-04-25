import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/screens/quiz_settings_screen.dart';

class CreateQuiz extends StatelessWidget {
  CreateQuiz({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return new QuizSettingsScreen(
          onSave: vm.onSave,
          quizExists: vm.quizExists,
          name: vm.name,
          files: vm.files,
          totalWordsCount: vm.totalWordsCount,
          quizSettings: vm.quizSettings,
          onNameUpdate: vm.onNameUpdate,
          onOptionsCountUpdate: vm.onOptionsCountUpdate,
          onWordsCountUpdate: vm.onWordsCountUpdate,

        );
      },
    );
  }
}

class _ViewModel {
  final List<String> files;
  final String name;
  final int totalWordsCount;
  final QuizSettings quizSettings;
  final OnSaveCallback onSave;
  final QuizExists quizExists;
  final Function(String) onNameUpdate;
  final Function(int) onWordsCountUpdate;
  final Function(int) onOptionsCountUpdate;

  _ViewModel({
    @required this.files,
    @required this.name,
    @required this.totalWordsCount,
    @required this.quizSettings,
    @required this.onSave,
    @required this.quizExists,
    @required this.onNameUpdate,
    @required this.onWordsCountUpdate,
    @required this.onOptionsCountUpdate
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      files: store.state.selectedFiles,
      name: store.state.quizName,
      totalWordsCount: store.state.totalWordsCount,
      quizSettings: store.state.quizSettings,
      onSave: (quiz) => store.dispatch(new AddQuizAction(quiz)),
      quizExists: (name) {
        return store.state.quizzes.where((q) => q.name == name).length > 0;
      },
      onNameUpdate: (name) {
        print('-- $name --');
        store.dispatch(new UpdateQuizName(name));
      },
      onWordsCountUpdate: (count) => store.dispatch(new UpdateWordsCount(count)),
      onOptionsCountUpdate: (count) => store.dispatch(new UpdateOptionsCount(count))
    );
  }
}
