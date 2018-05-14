import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/containers/quiz_form_view_model.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/screens/quiz_settings_form.dart';

class EditQuiz extends StatelessWidget {
  final Quiz quiz;

  EditQuiz({this.quiz});

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<AppState>(
      onInit: (store) {
        store.dispatch(new AddSelectedFileAction(quiz.filenames[0]));
        store.dispatch(new CalculateTotalWordsCountAction());
      },
      builder: (BuildContext context, Store<AppState> store) {
        QuizFormViewModel vm = QuizFormViewModel.fromStore(store);

        return new Scaffold(
            appBar: new AppBar(
              title: new Text(WordStudyLocalizations.of(context).quizSettings),
            ),
            body: new Builder(
                builder: (BuildContext context) {
                  return new SingleChildScrollView (
                      child: new QuizSettingsForm(
                        onSaveOrUpdate: vm.onSaveOrUpdate,
                        quizExists: vm.quizExists,
                        getTotalWordsCount: vm.getTotalWordsCount,
                        totalWordsCount: vm.totalWordsCount,
                        name: vm.name,
                        files: vm.files,
                        quiz: quiz
                      )
                  );
                }
            )
        );
      },
    );
  }
}

