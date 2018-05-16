import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/screens/quiz_settings_form.dart';

class QuizFormViewModel {
  final Quiz quiz;
  final List<String> files;
  final String name;
  final GetTotalWordsCount getTotalWordsCount;
  final int totalWordsCount; // Do not remove this, it is needed to compare widget versions
  final OnSaveOrUpdateCallback onSaveOrUpdate;
  final QuizExists quizExists;
  final Function(Quiz) onEditQuiz;

  QuizFormViewModel({
    @required this.files,
    @required this.name,
    @required this.onSaveOrUpdate,
    @required this.getTotalWordsCount,
    @required this.totalWordsCount,
    @required this.quizExists,
    @required this.quiz,
    @required this.onEditQuiz
  });

  static QuizFormViewModel fromStore(Store<AppState> store) {
    String name;

    if (store.state.selectedQuiz >= 0) {
      name = store.state.quizzes[store.state.selectedQuiz].name;
    }
    else {
      name = store.state.selectedFiles.length > 0 ? store.state.selectedFiles[0] : '';
    }

    return new QuizFormViewModel(
        quiz: store.state.quiz,
        files: store.state.selectedFiles,
        name: name,
        onSaveOrUpdate: (quiz) {
          if (store.state.selectedQuiz >= 0) {
            store.dispatch(new UpdateQuizAction(quiz));
          }
          else {
            store.dispatch(new AddQuizAction(quiz));
          }
        },
        totalWordsCount: store.state.totalWordsCount,
        getTotalWordsCount: () => store.state.totalWordsCount,
        quizExists: (name) {
          return store.state.quizzes.where((q) => q.name == name).length > 0;
        },
        onEditQuiz: (quiz) => store.dispatch(new EditQuizAction(quiz)),
    );
  }
}
