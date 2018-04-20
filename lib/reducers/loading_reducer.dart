import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';

final loadingReducer = combineTypedReducers<bool>([
  new ReducerBinding<bool, QuizzesLoadedAction>(_setLoaded),
  new ReducerBinding<bool, QuizzesNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}
