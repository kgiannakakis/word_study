import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/google_drive_state.dart';

final Reducer<GoogleDriveState> googleDriveReducer = combineReducers([
  new TypedReducer<GoogleDriveState, SetGoogleDriveMessageAction>(_setMessage),
  new TypedReducer<GoogleDriveState, SetGoogleDriveFilesAction>(_setFiles),
  new TypedReducer<GoogleDriveState, SetGoogleDriveUserAction>(_setCurrentUser),
  new TypedReducer<GoogleDriveState, GoogleDriveSignOutAction>(_signOut),
]);

GoogleDriveState _setMessage(GoogleDriveState state, SetGoogleDriveMessageAction action) {
  return state.copyWith(message: action.message);
}

GoogleDriveState _setFiles(GoogleDriveState state, SetGoogleDriveFilesAction action) {
  return state.copyWith(files: action.files);
}

GoogleDriveState _setCurrentUser(GoogleDriveState state, SetGoogleDriveUserAction action) {
  return state.copyWith(currentUser: action.currentUser);
}

GoogleDriveState _signOut(GoogleDriveState state, GoogleDriveSignOutAction action) {
  return const GoogleDriveState();
}
