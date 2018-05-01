import 'package:word_study/models/google_drive_file.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/models/google_drive_state.dart';

class SetGoogleDriveMessageAction {
  final GoogleDriveServiceMessage message;

  SetGoogleDriveMessageAction(this.message);
}

class SetGoogleDriveFilesAction {
  final List<GoogleDriveFile> files;

  SetGoogleDriveFilesAction(this.files);
}

class SetGoogleDriveUserAction {
  final GoogleSignInAccount currentUser;

  SetGoogleDriveUserAction(this.currentUser);
}

class GoogleDriveSignOutAction{}