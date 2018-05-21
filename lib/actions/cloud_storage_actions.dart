import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/models/cloud_storage_file.dart';
import 'package:word_study/models/cloud_storage_message.dart';
import 'package:word_study/models/cloud_storage_type.dart';

class SetCloudStorageMessageAction {
  final CloudStorageType type;
  final CloudStorageMessage message;

  SetCloudStorageMessageAction(this.type, this.message);
}

class SetCloudStorageFilesAction {
  final CloudStorageType type;
  final List<CloudStorageFile> files;

  SetCloudStorageFilesAction(this.type, this.files);
}

class SetGoogleDriveUserAction {
  final GoogleSignInAccount currentUser;

  SetGoogleDriveUserAction(this.currentUser);
}

class SetDropboxUserAction {
  final String email;
  final String displayName;

  SetDropboxUserAction(this.email, this.displayName);
}

class CloudStorageInitAction {
  final CloudStorageType type;

  CloudStorageInitAction(this.type);
}

class CloudStorageSignInAction {
  final CloudStorageType type;

  CloudStorageSignInAction(this.type);
}

class CloudStorageSignOutAction {
  final CloudStorageType type;

  CloudStorageSignOutAction(this.type);
}

class CloudStorageRefreshFilesAction {
  final CloudStorageType type;

  CloudStorageRefreshFilesAction(this.type);
}

class CloudStorageDownloadFileAction {
  final CloudStorageType type;
  final CloudStorageFile file;
  final Function onDownloaded;
  final Function onDownloadFailed;

  CloudStorageDownloadFileAction(this.type, this.file, this.onDownloaded, this.onDownloadFailed);
}