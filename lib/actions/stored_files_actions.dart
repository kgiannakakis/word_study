import 'package:word_study/models/stored_file.dart';

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

class RestoreFileAction {
  final String name;

  RestoreFileAction(this.name);
}

class AddFileAction {
  final StoredFile file;

  AddFileAction(this.file);
}