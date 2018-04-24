import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';

Reducer<bool> loadingReducer = combineReducers<bool>([
  new TypedReducer<bool, QuizzesLoadedAction>(_setLoaded),
  new TypedReducer<bool, QuizzesNotLoadedAction>(_setLoaded),
  new TypedReducer<bool, LoadQuizzesAction>(_setLoading),
  new TypedReducer<bool, FilesLoadedAction>(_setLoaded),
  new TypedReducer<bool, FilesNotLoadedAction>(_setLoaded),
  new TypedReducer<bool, LoadFilesAction>(_setLoading),
]);

bool _setLoaded(bool state, action) {
  return false;
}

bool _setLoading(bool state, action) {
  return true;
}
