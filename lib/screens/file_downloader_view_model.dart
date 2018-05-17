import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/cloud_storage_file.dart';
import 'package:word_study/models/cloud_storage_message.dart';
import 'package:word_study/models/cloud_storage_type.dart';
import 'package:word_study/models/google_drive_state.dart';
import 'package:word_study/models/stored_file.dart';

class FileDownloaderViewModel {
  final Function(StoredFile) onAddFile;
  final Function(CloudStorageType, CloudStorageMessage) onSetMessage;
  final Function(CloudStorageType, List<CloudStorageFile>) onSetFiles;
  final Function(CloudStorageType, GoogleSignInAccount) onSetCurrentUser;
  final Function(CloudStorageType) onSignIn;
  final Function(CloudStorageType) onSignOut;
  final Function(CloudStorageType) onRefreshFiles;
  final Function(CloudStorageType, CloudStorageFile, Function, Function) onDownloadFile;
  final GoogleDriveState googleDriveState;

  FileDownloaderViewModel({
    @required this.onAddFile,
    @required this.onSetMessage,
    @required this.onSetCurrentUser,
    @required this.onSetFiles,
    @required this.onSignIn,
    @required this.onSignOut,
    @required this.onRefreshFiles,
    @required this.onDownloadFile,
    @required this.googleDriveState
  });

  static FileDownloaderViewModel fromStore(Store<AppState> store) {
    return new FileDownloaderViewModel(
        onAddFile: (file) => store.dispatch(new AddFileAction(file)),
        onSetMessage: (type, msg) => store.dispatch(new SetCloudStorageMessageAction(type, msg)),
        onSetFiles: (type, files) => store.dispatch(new SetCloudStorageFilesAction(type, files)),
        onSetCurrentUser: (type, user) => store.dispatch(new SetCloudStorageUserAction(type, user)),
        onSignIn: (type) => store.dispatch(new CloudStorageSignInAction(type)),
        onSignOut: (type) => store.dispatch(new CloudStorageSignOutAction(type)),
        onRefreshFiles: (type) => store.dispatch(new CloudStorageRefreshFilesAction(type)),
        onDownloadFile: (type, file, onDownloaded, onDownloadFailed) =>
            store.dispatch(new CloudStorageDownloadFileAction(type, file, onDownloaded, onDownloadFailed)),
        googleDriveState: store.state.googleDriveState
    );
  }
}
