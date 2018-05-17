import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/google_drive_state.dart';

final Reducer<GoogleDriveState> googleDriveReducer = combineReducers([
  new TypedReducer<GoogleDriveState, SetCloudStorageMessageAction>(_setMessage),
  new TypedReducer<GoogleDriveState, SetCloudStorageFilesAction>(_setFiles),
  new TypedReducer<GoogleDriveState, SetCloudStorageUserAction>(_setCurrentUser),
  new TypedReducer<GoogleDriveState, CloudStorageSignOutAction>(_signOut),
]);

GoogleDriveState _setMessage(GoogleDriveState state, SetCloudStorageMessageAction action) {
  return state.copyWith(message: action.message);
}

GoogleDriveState _setFiles(GoogleDriveState state, SetCloudStorageFilesAction action) {
  return state.copyWith(files: action.files);
}

GoogleDriveState _setCurrentUser(GoogleDriveState state, SetCloudStorageUserAction action) {
  return state.copyWith(currentUser: action.currentUser);
}

GoogleDriveState _signOut(GoogleDriveState state, CloudStorageSignOutAction action) {
  return const GoogleDriveState();
}
