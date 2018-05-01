import 'dart:async';

import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/services/file_service.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/words/file_word_provider.dart';
import 'package:word_study/words/quiz_provider.dart';

List<Middleware<AppState>> createMiddleware([
  QuizProvider quizProvider = const QuizProvider(const FileService())
]) {
  final saveQuizzes = _createSaveQuizzes(quizProvider);
  final loadQuizzes = _createLoadQuizzes(quizProvider);
  final calculateWordCount = _createCalculateWordCount();
  final loadFiles = _createLoadFiles();

  return <Middleware<AppState>>[
    new TypedMiddleware<AppState, LoadQuizzesAction>(loadQuizzes),
    new TypedMiddleware<AppState, AddQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, DeleteQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, QuizzesLoadedAction>(saveQuizzes),
    new TypedMiddleware<AppState, CalculateTotalWordsCountAction>(calculateWordCount),
    new TypedMiddleware<AppState, LoadFilesAction>(loadFiles),
  ];
}

Middleware<AppState> _createSaveQuizzes(QuizProvider quizProvider) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    quizProvider.saveQuizzes(store.state.quizzes)
        .then((ok) {
        if (!ok) {
          print('Failed to save quizzes!');
          store.dispatch(LoadQuizzesAction);
        }
      }
    );
  };
}

Middleware<AppState> _createLoadQuizzes(QuizProvider quizProvider) {
  return (Store<AppState> store, action, NextDispatcher next) {

    quizProvider.loadQuizzes().then((quizzes) {
      store.dispatch(
        new QuizzesLoadedAction(quizzes),
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
