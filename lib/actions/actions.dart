import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/stored_file.dart';

class LoadQuizzesAction {}

class QuizzesNotLoadedAction {}

class QuizzesLoadedAction {
  final List<Quiz> quizzes;

  QuizzesLoadedAction(this.quizzes);
}

class DeleteQuizAction {
  final String name;

  DeleteQuizAction(this.name);
}

class AddQuizAction {
  final Quiz quiz;

  AddQuizAction(this.quiz);
}

class AddSelectedFileAction {
  final String file;

  AddSelectedFileAction(this.file);
}

class DeleteSelectedFileAction {
  final String file;

  DeleteSelectedFileAction(this.file);
}

class ClearSelectedFilesAction {}

class UpdateTotalWordCountAction {
  final int totalWordCount;

  UpdateTotalWordCountAction(this.totalWordCount);
}

class LoadFilesAction {}

class FilesNotLoadedAction {}

class FilesLoadedAction {
  final List<StoredFile> files;

  FilesLoadedAction(this.files);
}

class DeleteFileAction {
  final String name;

  DeleteFileAction(this.name);
}

class AddFileAction {
  final StoredFile file;

  AddFileAction(this.file);
}