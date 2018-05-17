import 'dart:async';

import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/cloud_storage_file.dart';
import 'package:word_study/models/cloud_storage_message.dart';
import 'package:word_study/models/cloud_storage_type.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:word_study/services/dropbox_service.dart';
import 'package:word_study/services/file_service.dart';
import 'package:word_study/services/google_drive_service.dart';
import 'package:word_study/words/file_word_provider.dart';
import 'package:word_study/words/quiz_provider.dart';

List<Middleware<AppState>> createMiddleware([
  QuizProvider quizProvider = const QuizProvider(const FileService()),
  FileService fileService = const FileService(),
  GoogleDriveService googleDriveService
]) {
  final saveQuizzes = _createSaveQuizzes(quizProvider);
  final loadQuizzes = _createLoadQuizzes(quizProvider);
  final addQuiz = _createAddQuiz(quizProvider);
  final deleteQuiz = _createDeleteQuiz(quizProvider);
  final updateQuiz = _createUpdateQuiz(quizProvider);
  final calculateWordCount = _createCalculateWordCount();
  final loadFiles = _createLoadFiles();
  final deleteFile = _deleteFile(fileService);
  final restoreFile = _restoreFile(fileService);
  final cloudStorageInit = _cloudStorageInit(googleDriveService);
  final cloudStorageSignIn = _cloudStorageSignIn(googleDriveService);
  final cloudStorageSignOut = _cloudStorageSignOut(googleDriveService);
  final cloudStorageRefreshFiles = _cloudStorageRefreshFiles(googleDriveService);
  final cloudStorageDownloadFile = _cloudStorageDownloadFile(googleDriveService);

  return <Middleware<AppState>>[
    new TypedMiddleware<AppState, LoadQuizzesAction>(loadQuizzes),
    new TypedMiddleware<AppState, AddQuizAction>(addQuiz),
    new TypedMiddleware<AppState, DeleteQuizAction>(deleteQuiz),
    new TypedMiddleware<AppState, UpdateQuizAction>(updateQuiz),
    new TypedMiddleware<AppState, QuizzesLoadedAction>(saveQuizzes),
    new TypedMiddleware<AppState, CalculateTotalWordsCountAction>(calculateWordCount),
    new TypedMiddleware<AppState, LoadFilesAction>(loadFiles),
    new TypedMiddleware<AppState, DeleteFileAction>(deleteFile),
    new TypedMiddleware<AppState, RestoreFileAction>(restoreFile),
    new TypedMiddleware<AppState, CloudStorageInitAction>(cloudStorageInit),
    new TypedMiddleware<AppState, CloudStorageSignInAction>(cloudStorageSignIn),
    new TypedMiddleware<AppState, CloudStorageSignOutAction>(cloudStorageSignOut),
    new TypedMiddleware<AppState, CloudStorageRefreshFilesAction>(cloudStorageRefreshFiles),
    new TypedMiddleware<AppState, CloudStorageDownloadFileAction>(cloudStorageDownloadFile),
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

Middleware<AppState> _createAddQuiz(QuizProvider quizProvider) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    Quiz quiz = (action as AddQuizAction).quiz;

    quizProvider.addQuiz(quiz)
        .then((id) {
      if (id <= 0) {
        print('Failed to add quiz!');
        store.dispatch(LoadQuizzesAction);
      }
      else {
        store.dispatch(SetAddedQuizIdAction(id));
      }
    }
    );
  };
}

Middleware<AppState> _createDeleteQuiz(QuizProvider quizProvider) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    String quizName = (action as DeleteQuizAction).name;

    quizProvider.deleteQuiz(quizName)
        .then((count) {
      if (count <=0 ) {
        print('Failed to delete quiz $quizName');
        store.dispatch(LoadQuizzesAction);
      }
    }
    );
  };
}

Middleware<AppState> _createUpdateQuiz(QuizProvider quizProvider) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    Quiz quiz = (action as UpdateQuizAction).quiz;

    quizProvider.updateQuiz(quiz)
        .then((count) {
      if (count < 1) {
        print('Failed to update quiz ${quiz}');
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

Middleware<AppState> _deleteFile(FileService fileService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    String filename = (action as DeleteFileAction).name;

    fileService.deleteFile(filename).then((ok) {
      if (ok) {
        next(action);
      }
    });
  };
}

Middleware<AppState> _restoreFile(FileService fileService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    StoredFile deletedFile = (action as RestoreFileAction).file;
    fileService.undeleteFile(deletedFile).then((ok) {
      if (ok) {
        store.dispatch(new AddFileAction(new StoredFile(
            name: deletedFile.name,
            created: deletedFile.created
        )));
      }
    });

    next(action);
  };
}

Middleware<AppState> _cloudStorageInit(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    var type = (action as CloudStorageInitAction).type;

    switch(type) {
      case CloudStorageType.GoogleDrive:
        googleDriveService.onUpdateState = ({CloudStorageMessage msg,
          List<CloudStorageFile> files}) {
          if (files != null) {
            store.dispatch(new SetCloudStorageFilesAction(type, files));
          }
          if (msg != null) {
            store.dispatch(new SetCloudStorageMessageAction(type, msg));
          }
        };
        googleDriveService.onUpdateUser = (user) {
          store.dispatch(new SetCloudStorageUserAction(type, user));
          if (user != null) {
            googleDriveService.initGetFiles();
          }
        };
        googleDriveService.init();
        break;
      case CloudStorageType.DropBox:
        DropBoxService dropBoxService = new DropBoxService();

        dropBoxService.init().then((_) => next(action));
        break;
    }

    next(action);
  };
}

Middleware<AppState> _cloudStorageSignIn(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    var type = (action as CloudStorageSignInAction).type;

    switch(type) {
      case CloudStorageType.GoogleDrive:
        googleDriveService.handleSignIn();
        break;
      case CloudStorageType.DropBox:
        break;
    }

    next(action);
  };
}

Middleware<AppState> _cloudStorageSignOut(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    var type = (action as CloudStorageSignOutAction).type;

    switch(type) {
      case CloudStorageType.GoogleDrive:
        googleDriveService.handleSignOut();
        break;
      case CloudStorageType.DropBox:
        break;
    }

    next(action);
  };
}

Middleware<AppState> _cloudStorageRefreshFiles(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    var type = (action as CloudStorageRefreshFilesAction).type;

    switch(type) {
      case CloudStorageType.GoogleDrive:
        googleDriveService.initGetFiles();
        break;
      case CloudStorageType.DropBox:
        break;
    }

    next(action);
  };
}

Middleware<AppState> _cloudStorageDownloadFile(GoogleDriveService googleDriveService) {
  return (Store<AppState> store, action, NextDispatcher next) {

    var type = (action as CloudStorageDownloadFileAction).type;
    var file = (action as CloudStorageDownloadFileAction).file;

    switch(type) {
      case CloudStorageType.GoogleDrive:
        googleDriveService.downloadFile(file).then((ok) {
          if (ok) {
            (action as CloudStorageDownloadFileAction).onDownloaded();
            store.dispatch(new AddFileAction(
                new StoredFile(
                    name: file.name,
                    created: DateTime.now()
                )
            ));
          } else {
            (action as CloudStorageDownloadFileAction).onDownloadFailed();
          }
        });
        break;
      case CloudStorageType.DropBox:
        break;
    }

    next(action);
  };
}