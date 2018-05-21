import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/cloud_storage_type.dart';
import 'package:word_study/models/dropbox_state.dart';
import 'package:word_study/models/dropbox_user.dart';

final Reducer<DropboxState> dropboxReducer = combineReducers([
  new TypedReducer<DropboxState, SetCloudStorageMessageAction>(_setMessage),
  new TypedReducer<DropboxState, SetCloudStorageFilesAction>(_setFiles),
  new TypedReducer<DropboxState, SetDropboxUserAction>(_setCurrentUser),
  new TypedReducer<DropboxState, CloudStorageSignOutAction>(_signOut),
]);

DropboxState _setMessage(DropboxState state, SetCloudStorageMessageAction action) {
  if (action.type == CloudStorageType.Dropbox) {
    return state.copyWith(message: action.message);
  }
  return state;
}

DropboxState _setFiles(DropboxState state, SetCloudStorageFilesAction action) {
  if (action.type == CloudStorageType.Dropbox) {
    return state.copyWith(files: action.files);
  }
  return state;
}

DropboxState _setCurrentUser(DropboxState state, SetDropboxUserAction action) {
  return state.copyWith(currentUser: DropboxUser(
      displayName: action.displayName,
      email: action.email)
  );
}

DropboxState _signOut(DropboxState state, CloudStorageSignOutAction action) {
  if (action.type == CloudStorageType.Dropbox) {
    return const DropboxState();
  }
  return state;
}
