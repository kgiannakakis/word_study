import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';

Reducer<List<String>> selectedFilesReducer = combineReducers([
  new TypedReducer<List<String>, AddSelectedFileAction>(_addSelectedFile),
  new TypedReducer<List<String>, DeleteSelectedFileAction>(_deleteSelectedFile),
  new TypedReducer<List<String>, ClearSelectedFilesAction>(_setNoSelectedFiles)
]);

List<String> _addSelectedFile(List<String> files, AddSelectedFileAction action) {
  return new List.from(files)..add(action.file);
}

List<String> _deleteSelectedFile(List<String> files, DeleteSelectedFileAction action) {
  return files.where((file) => file != action.file).toList();
}

List<String> _setNoSelectedFiles(List<String> files, ClearSelectedFilesAction action) {
  return [];
}

