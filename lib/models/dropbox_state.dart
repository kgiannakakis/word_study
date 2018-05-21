import 'package:word_study/models/cloud_storage_file.dart';
import 'package:word_study/models/cloud_storage_message.dart';
import 'package:word_study/models/dropbox_user.dart';

class DropboxState {
  final CloudStorageMessage message;
  final List<CloudStorageFile> files;
  final DropboxUser currentUser;

  const DropboxState({this.message = CloudStorageMessage.starting,
    this.files = const [],
    this.currentUser});

  DropboxState copyWith({CloudStorageMessage message,
    List<CloudStorageFile> files,
    DropboxUser currentUser}) {
    return new DropboxState(
        message: message ?? this.message,
        files: files ?? this.files,
        currentUser: currentUser ?? this.currentUser
    );
  }

  @override
  int get hashCode => message.hashCode ^ files.hashCode ^
  currentUser.hashCode ^ currentUser.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DropboxState &&
              other.message == message &&
              other.files == files &&
              other.currentUser == currentUser;
}