import 'dart:async';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/words/quiz_provider.dart';
import 'package:word_study/words/file_word_provider.dart';
import 'package:word_study/files/file_service.dart';

List<Middleware<AppState>> createMiddleware() {
  final saveQuizzes = _createSaveQuizzes();
  final loadQuizzes = _createLoadQuizzes();
  final calculateWordCount = _createCalculateWordCount();
  final loadFiles = _createLoadFiles();

  return <Middleware<AppState>>[
    new TypedMiddleware<AppState, LoadQuizzesAction>(loadQuizzes),
    new TypedMiddleware<AppState, AddQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, DeleteQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, QuizzesLoadedAction>(saveQuizzes),
    new TypedMiddleware<AppState, AddSelectedFileAction>(calculateWordCount),
    new TypedMiddleware<AppState, DeleteSelectedFileAction>(calculateWordCount),
    new TypedMiddleware<AppState, ClearSelectedFilesAction>(calculateWordCount),
    new TypedMiddleware<AppState, LoadFilesAction>(loadFiles),
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

    next(action);

    _calculateWordCount(store.state.selectedFiles)
        .then((totalWordCount) => store.dispatch(new UpdateTotalWordCountAction(totalWordCount)));
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

Middleware<AppState> _createLoadFiles() {
  return (Store<AppState> store, action, NextDispatcher next) {

    FileService fileService = new FileService();

    fileService.listFiles().then((files) {
      store.dispatch(new FilesLoadedAction(files));
    }).catchError((e) {
      print(e);
      store.dispatch(new FilesNotLoadedAction());
    });

    next(action);
  };
}
