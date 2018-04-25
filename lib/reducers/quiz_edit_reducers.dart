import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/quiz_settings.dart';

Reducer<int> totalWordsCountReducer =
  new TypedReducer<int, UpdateTotalWordsCountAction>(_updateTotalWordsCount);

int _updateTotalWordsCount(int totalWordCount, UpdateTotalWordsCountAction action) {
  return action.totalWordsCount;
}

final Reducer<QuizSettings> quizEditReducer = combineReducers([
  new TypedReducer<QuizSettings, UpdateWordsCount>(_updateWordsCount),
  new TypedReducer<QuizSettings, UpdateOptionsCount>(_updateOptionsCount),
]);

QuizSettings _updateWordsCount(QuizSettings settings, UpdateWordsCount action) {
  return settings.copyWith(wordsCount: action.wordsCount);
}

QuizSettings _updateOptionsCount(QuizSettings settings, UpdateOptionsCount action) {
  return settings.copyWith(optionsCount: action.optionsCount);
}

Reducer<String> quizNameReducer =
new TypedReducer<String, UpdateQuizName>(_updateQuizName);

String _updateQuizName(String totalWordCount, UpdateQuizName action) {
  return action.name;
}

