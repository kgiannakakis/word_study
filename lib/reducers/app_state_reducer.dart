import 'package:word_study/models/appstate.dart';
import 'package:word_study/reducers/loading_reducer.dart';
import 'package:word_study/reducers/quizzes_reducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return new AppState(
    isLoading: loadingReducer(state.isLoading, action),
    quizzes: quizzesReducer(state.quizzes, action),
  );
}
