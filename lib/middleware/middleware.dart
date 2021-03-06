import 'dart:async';

import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/google_drive_file.dart';
import 'package:word_study/models/google_drive_state.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:word_study/services/file_service.dart';
import 'package:word_study/services/google_drive_service.dart';
import 'package:word_study/words/file_word_provider.dart';
import 'package:word_study/words/quiz_provider.dart';

List<Middleware<AppState>> createMiddleware([
  QuizProvider quizProvider = const QuizProvider(const FileService()),
  GoogleDriveService googleDriveService
]) {
  final saveQuizzes = _createSaveQuizzes(quizProvider);
  final loadQuizzes = _createLoadQuizzes(quizProvider);
  final calculateWordCount = _createCalculateWordCount();
  final loadFiles = _createLoadFiles();
  final googleDriveInit = _googleDriveInit(googleDriveService);
  final googleDriveSignIn = _googleDriveSignIn(googleDriveService);
  final googleDriveSignOut = _googleDriveSignOut(googleDriveService);
  final googleDriveRefreshFiles = _googleDriveRefreshFiles(googleDriveService);
  final googleDriveDownloadFile = _googleDriveDownloadFile(googleDriveService);

  return <Middleware<AppState>>[
    new TypedMiddleware<AppState, LoadQuizzesAction>(loadQuizzes),
    new TypedMiddleware<AppState, AddQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, DeleteQuizAction>(saveQuizzes),
    new TypedMiddleware<AppState, QuizzesLoadedAction>(saveQuizzes),
    new TypedMiddleware<AppState, CalculateTotalWordsCountAction>(calculateWordCount),
    new TypedMiddleware<AppState, LoadFilesAction>(loadFiles),
    new TypedMiddleware<AppState, GoogleDriveInitAction>(googleDriveInit),
    new TypedMiddleware<AppState, GoogleDriveSignInAction>(googleDriveSignIn),
    new TypedMiddleware<AppState, GoogleDriveSignOutAction>(googleDriveSignOut),
    new TypedMiddleware<AppState, GoogleDriveRefreshFilesAction>(googleDriveRefreshFiles),
    new TypedMiddleware<AppState, GoogleDriveDownloadFileAction>(googleDriveDownloadFile),
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

Middleware<AppState> _googleDriveInit(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    googleDriveService.onUpdateState = ({GoogleDriveServiceMessage msg,
                                         List<GoogleDriveFile> files}) {
      if (files != null) {
        store.dispatch(new SetGoogleDriveFilesAction(files));
      }
      if (msg != null) {
        store.dispatch(new SetGoogleDriveMessageAction(msg));
      }
    };
    googleDriveService.onUpdateUser = (user) {
      store.dispatch(new SetGoogleDriveUserAction(user));
      if (user != null) {
        googleDriveService.initGetFiles();
      }
    };
    googleDriveService.init();

    next(action);
  };
}

Middleware<AppState> _googleDriveSignIn(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    googleDriveService.handleSignIn();

    next(action);
  };
}

Middleware<AppState> _googleDriveSignOut(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    googleDriveService.handleSignOut();

    next(action);
  };
}

Middleware<AppState> _googleDriveRefreshFiles(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    googleDriveService.initGetFiles();

    next(action);
  };
}

Middleware<AppState> _googleDriveDownloadFile(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    GoogleDriveFile file = (action as GoogleDriveDownloadFileAction).file;
    googleDriveService.downloadFile(file).then((ok) {
      if (ok) {
        store.dispatch(new AddFileAction(
            new StoredFile(
              name: file.name,
              created: DateTime.now()
            )
        ));
      }
    });

    next(action);
  };
}
