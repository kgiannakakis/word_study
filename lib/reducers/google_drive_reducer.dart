import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/cloud_storage_type.dart';
import 'package:word_study/models/google_drive_state.dart';

final Reducer<GoogleDriveState> googleDriveReducer = combineReducers([
  new TypedReducer<GoogleDriveState, SetCloudStorageMessageAction>(_setMessage),
  new TypedReducer<GoogleDriveState, SetCloudStorageFilesAction>(_setFiles),
  new TypedReducer<GoogleDriveState, SetGoogleDriveUserAction>(_setCurrentUser),
  new TypedReducer<GoogleDriveState, CloudStorageSignOutAction>(_signOut),
]);

GoogleDriveState _setMessage(GoogleDriveState state, SetCloudStorageMessageAction action) {
  if (action.type == CloudStorageType.GoogleDrive) {
    return state.copyWith(message: action.message);
  }
  return state;
}

GoogleDriveState _setFiles(GoogleDriveState state, SetCloudStorageFilesAction action) {
  if (action.type == CloudStorageType.GoogleDrive) {
    return state.copyWith(files: action.files);
  }
  return state;
}

GoogleDriveState _setCurrentUser(GoogleDriveState state, SetGoogleDriveUserAction action) {
  return state.copyWith(currentUser: action.currentUser);
}

GoogleDriveState _signOut(GoogleDriveState state, CloudStorageSignOutAction action) {
  if (action.type == CloudStorageType.GoogleDrive) {
    return const GoogleDriveState();
  }
  return state;
}
