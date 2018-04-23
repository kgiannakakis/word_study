import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/state/appstate.dart';
import 'package:word_study/words/quizprovider.dart';

List<Middleware<AppState>> createStoreQuizzesMiddleware() {
  final saveQuizzes = _createSaveQuizzes();
  final loadQuizzes = _createLoadQuizzes();

  return <Middleware<AppState>>[
    new TypedMiddleware<AppState, LoadQuizzesAction>(loadQuizzes),
    new TypedMiddleware<AppState, AddQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, DeleteQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, QuizzesLoadedAction>(saveQuizzes),
  ];
}

Middleware<AppState> _createSaveQuizzes() {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);
  };
}

Middleware<AppState> _createLoadQuizzes() {
  return (Store<AppState> store, action, NextDispatcher next) {
    QuizProvider repository = new QuizProvider();

    repository.init().then((_) {
      store.dispatch(
        new QuizzesLoadedAction(repository.allQuizzes),
      );
    },)
    .catchError((e) {
        store.dispatch(new QuizzesNotLoadedAction());
      }
    );

    next(action);
  };
}
