import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/storedfile.dart';

final Reducer<List<StoredFile>> filesReducer = combineReducers([
  new TypedReducer<List<StoredFile>, FilesLoadedAction>(_setLoadedFiles),
  new TypedReducer<List<StoredFile>, FilesNotLoadedAction>(_setNoFiles),
]);

List<StoredFile> _setLoadedFiles(List<StoredFile> files, FilesLoadedAction action) {
  return action.files;
}

List<StoredFile> _setNoFiles(List<StoredFile> files, FilesNotLoadedAction action) {
  return [];
}
