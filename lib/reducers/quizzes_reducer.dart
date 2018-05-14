import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/quiz.dart';

final Reducer<List<Quiz>> quizzesReducer = combineReducers([
  new TypedReducer<List<Quiz>, AddQuizAction>(_addQuiz),
  new TypedReducer<List<Quiz>, DeleteQuizAction>(_deleteQuiz),
  new TypedReducer<List<Quiz>, QuizzesLoadedAction>(_setLoadedQuizzes),
  new TypedReducer<List<Quiz>, QuizzesNotLoadedAction>(_setNoQuizzes),
  new TypedReducer<List<Quiz>, SetAddedQuizId>(_setAddedQuizId),
  new TypedReducer<List<Quiz>, UpdateQuiz>(_updateQuiz)
]);

final Reducer<int> selectQuizReducer =
new TypedReducer<int, SelectQuizAction>(_selectQuiz);

int _selectQuiz(int quiz, SelectQuizAction action) {
  return action.quizIndex;
}

List<Quiz> _addQuiz(List<Quiz> quizzes, AddQuizAction action) {
  return new List<Quiz>.from(quizzes)..add(action.quiz);
}

List<Quiz> _deleteQuiz(List<Quiz> quizzes, DeleteQuizAction action) {
  return quizzes.where((quiz) => quiz.name != action.name).toList();
}

List<Quiz> _setLoadedQuizzes(List<Quiz> quizzes, QuizzesLoadedAction action) {
  return action.quizzes;
}

List<Quiz> _setNoQuizzes(List<Quiz> quizzes, QuizzesNotLoadedAction action) {
  return [];
}

List<Quiz> _setAddedQuizId(List<Quiz> quizzes, SetAddedQuizId action) {
  var newQuizzes = List<Quiz>.from(quizzes);
  for(int i=0; i<newQuizzes.length; i++) {
    if (newQuizzes[i].id == null) {
      newQuizzes[i] = newQuizzes[i].copyWith(id: action.id);
      break;
    }
  }
  return newQuizzes;
}

List<Quiz> _updateQuiz(List<Quiz> quizzes, UpdateQuiz action) {
  var newQuizzes = List<Quiz>.from(quizzes);
  for(int i=0; i<newQuizzes.length; i++) {
    if (newQuizzes[i].id == null) {
      newQuizzes[i] = action.quiz;
      break;
    }
  }
  return newQuizzes;
}


