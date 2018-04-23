import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';

Reducer<bool> loadingReducer = combineReducers<bool>([
  new TypedReducer<bool, QuizzesLoadedAction>(_setLoaded),
  new TypedReducer<bool, QuizzesNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}
