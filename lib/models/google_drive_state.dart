import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/models/google_drive_file.dart';

class GoogleDriveState {
  final String messageText;
  final List<GoogleDriveFile> files;
  final GoogleSignInAccount currentUser;

  const GoogleDriveState({this.messageText = '',
                          this.files = const [],
                          this.currentUser});

  GoogleDriveState copyWith({String messageText,
    List<GoogleDriveFile> files,
    GoogleSignInAccount currentUser}) {
      return new GoogleDriveState(
        messageText: messageText ?? this.messageText,
        files: files ?? this.files,
        currentUser: currentUser ?? this.currentUser
      );
  }

  @override
  int get hashCode => messageText.hashCode ^ files.hashCode ^
                      currentUser.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GoogleDriveState &&
          other.messageText == messageText &&
          other.files == files &&
          other.currentUser == currentUser;
}