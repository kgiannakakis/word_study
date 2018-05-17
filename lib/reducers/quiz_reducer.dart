import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/quiz.dart';

final Reducer<Quiz> quizReducer = combineReducers([
  new TypedReducer<Quiz, EditQuizAction>(_editQuiz),
]);

Quiz _editQuiz(Quiz quiz, EditQuizAction action) {
  if (quiz == null) {
    return action.quiz;
  }

  var newSettings = quiz.settings;
  if (action.quiz != null && action.quiz.settings != null) {
    if (newSettings == null) {
      newSettings = action.quiz.settings;
    }
    else {
      newSettings = newSettings.copyWith(wordsCount: action.quiz.settings.wordsCount,
                                         optionsCount: action.quiz.settings.optionsCount,
                                         inverse: action.quiz.settings.inverse);
    }
  }

  return quiz.copyWith(name: action.quiz.name,
                       filenames: action.quiz.filenames,
                       settings: newSettings);
}