import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/models/google_drive_file.dart';

enum GoogleDriveServiceMessage {
  starting,
  failedToConnect,
  folderFound,
  folderNotFound,
  folderEmpty,
  loadingFiles
}

class GoogleDriveState {
  final GoogleDriveServiceMessage message;
  final List<GoogleDriveFile> files;
  final GoogleSignInAccount currentUser;

  const GoogleDriveState({this.message = GoogleDriveServiceMessage.starting,
                          this.files = const [],
                          this.currentUser});

  GoogleDriveState copyWith({GoogleDriveServiceMessage message,
    List<GoogleDriveFile> files,
    GoogleSignInAccount currentUser}) {
      return new GoogleDriveState(
        message: message ?? this.message,
        files: files ?? this.files,
        currentUser: currentUser ?? this.currentUser
      );
  }

  @override
  int get hashCode => message.hashCode ^ files.hashCode ^
                      currentUser.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GoogleDriveState &&
          other.message == message &&
          other.files == files &&
          other.currentUser == currentUser;
}