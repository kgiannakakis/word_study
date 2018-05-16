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
  return quiz.copyWith(name: action.quiz.name,
                       filenames: action.quiz.filenames,
                       settings: action.quiz.settings);
}