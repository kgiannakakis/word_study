import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/models/cloud_storage_file.dart';
import 'package:word_study/models/cloud_storage_message.dart';

class GoogleDriveState {
  final CloudStorageMessage message;
  final List<CloudStorageFile> files;
  final GoogleSignInAccount currentUser;

  const GoogleDriveState({this.message = CloudStorageMessage.starting,
                          this.files = const [],
                          this.currentUser});

  GoogleDriveState copyWith({CloudStorageMessage message,
    List<CloudStorageFile> files,
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