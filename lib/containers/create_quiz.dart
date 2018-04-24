import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/app_state.dart';
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
          name: vm.name,
          files: vm.files,
          totalWordsCount: vm.totalWordsCount,
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

  _ViewModel({
    @required this.files,
    @required this.name,
    @required this.totalWordsCount,
    @required this.onSave
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
        files: store.state.selectedFiles,
        name: store.state.selectedFiles.length > 0 ? store.state.selectedFiles[0] : '',
        totalWordsCount: store.state.totalWordsCount,
        onSave: (quiz) {
          store.dispatch(new AddQuizAction(quiz));
        },
    );
  }
}
