import 'dart:async';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/appstate.dart';
import 'package:word_study/words/quizprovider.dart';
import 'package:word_study/words/filewordprovider.dart';

List<Middleware<AppState>> createStoreQuizzesMiddleware() {
  final saveQuizzes = _createSaveQuizzes();
  final loadQuizzes = _createLoadQuizzes();
  final calculateWordCount = _createCalculateWordCount();

  return <Middleware<AppState>>[
    new TypedMiddleware<AppState, LoadQuizzesAction>(loadQuizzes),
    new TypedMiddleware<AppState, AddQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, DeleteQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, QuizzesLoadedAction>(saveQuizzes),
    new TypedMiddleware<AppState, AddSelectedFileAction>(calculateWordCount),
    new TypedMiddleware<AppState, DeleteSelectedFileAction>(calculateWordCount),
    new TypedMiddleware<AppState, ClearSelectedFilesAction>(calculateWordCount)
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

Middleware<AppState> _createCalculateWordCount() {
  return (Store<AppState> store, action, NextDispatcher next) {

    _calculateWordCount(store.state.selectedFiles)
        .then((totalWordCount) => store.dispatch(new UpdateTotalWordCountAction(totalWordCount)));

    next(action);
  };
}

Future<int> _calculateWordCount(List<String> files) async {
  int totalWordCount = 0;
  for(String file in files) {
    FileWordProvider wordProvider = new FileWordProvider(file);
    bool ok = await wordProvider.init();
    if (ok) {
      totalWordCount += wordProvider.length;
    }
  }
  return totalWordCount;
}
