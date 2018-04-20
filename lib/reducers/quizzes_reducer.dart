import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/words/quiz.dart';

final quizzesReducer = combineTypedReducers<List<Quiz>>([
  new ReducerBinding<List<Quiz>, AddQuizAction>(_addQuiz),
  new ReducerBinding<List<Quiz>, QuizzesLoadedAction>(_setLoadedQuizzes),
  new ReducerBinding<List<Quiz>, QuizzesNotLoadedAction>(_setNoQuizzes),
]);

List<Quiz> _addQuiz(List<Quiz> quizzes, AddQuizAction action) {
  return new List.from(quizzes)..add(action.quiz);
}

List<Quiz> _setLoadedQuizzes(List<Quiz> quizzes, QuizzesLoadedAction action) {
  return action.quizzes;
}

List<Quiz> _setNoQuizzes(List<Quiz> quizzes, QuizzesNotLoadedAction action) {
  return [];
}
