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