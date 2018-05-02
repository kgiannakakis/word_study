import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:word_study/models/google_drive_file.dart';
import 'package:word_study/models/google_drive_state.dart';

class FileDownloaderViewModel {
  final Function(StoredFile) onAddFile;
  final Function(GoogleDriveServiceMessage) onSetMessage;
  final Function(List<GoogleDriveFile>) onSetFiles;
  final Function(GoogleSignInAccount) onSetCurrentUser;
  final Function onSignIn;
  final Function onSignOut;
  final Function onRefreshFiles;
  final Function(GoogleDriveFile) onDownloadFile;
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
        onSetMessage: (msg) => store.dispatch(new SetGoogleDriveMessageAction(msg)),
        onSetFiles: (files) => store.dispatch(new SetGoogleDriveFilesAction(files)),
        onSetCurrentUser: (user) => store.dispatch(new SetGoogleDriveUserAction(user)),
        onSignIn: () => store.dispatch(new GoogleDriveSignInAction()),
        onSignOut: () => store.dispatch(new GoogleDriveSignOutAction()),
        onRefreshFiles: () => store.dispatch(new GoogleDriveRefreshFilesAction()),
        onDownloadFile: (file) => store.dispatch(new GoogleDriveDownloadFileAction(file)),
        googleDriveState: store.state.googleDriveState
    );
  }
}
