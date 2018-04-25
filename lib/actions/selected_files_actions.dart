class AddSelectedFileAction {
  final String file;

  AddSelectedFileAction(this.file);
}

class DeleteSelectedFileAction {
  final String file;

  DeleteSelectedFileAction(this.file);
}

class ClearSelectedFilesAction {}

class UpdateTotalWordsCountAction {
  final int totalWordsCount;

  UpdateTotalWordsCountAction(this.totalWordsCount);
}