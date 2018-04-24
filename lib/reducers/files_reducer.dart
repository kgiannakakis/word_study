import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/stored_file.dart';

final Reducer<List<StoredFile>> filesReducer = combineReducers([
  new TypedReducer<List<StoredFile>, FilesLoadedAction>(_setLoadedFiles),
  new TypedReducer<List<StoredFile>, FilesNotLoadedAction>(_setNoFiles),
  new TypedReducer<List<StoredFile>, AddFileAction>(_addFile),
  new TypedReducer<List<StoredFile>, DeleteFileAction>(_deleteFile),
]);

List<StoredFile> _setLoadedFiles(List<StoredFile> files, FilesLoadedAction action) {
  return action.files;
}

List<StoredFile> _setNoFiles(List<StoredFile> files, FilesNotLoadedAction action) {
  return [];
}

List<StoredFile> _addFile(List<StoredFile> files, AddFileAction action) {
  return new List.from(files)..add(action.file);
}

List<StoredFile> _deleteFile(List<StoredFile> files, DeleteFileAction action) {
  return files.where((file) => file.name != action.name).toList();
}
