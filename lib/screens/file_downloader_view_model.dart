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
  final Function(String) onSetMessage;
  final Function(List<GoogleDriveFile>) onSetFiles;
  final Function(GoogleSignInAccount) onSetCurrentUser;
  final Function onSignOut;
  final GoogleDriveState googleDriveState;

  FileDownloaderViewModel({
    @required this.onAddFile,
    @required this.onSetMessage,
    @required this.onSetCurrentUser,
    @required this.onSetFiles,
    @required this.onSignOut,
    @required this.googleDriveState
  });

  static FileDownloaderViewModel fromStore(Store<AppState> store) {
    return new FileDownloaderViewModel(
        onAddFile: (file) => store.dispatch(new AddFileAction(file)),
        onSetMessage: (msg) => store.dispatch(new SetGoogleDriveMessageAction(msg)),
        onSetFiles: (files) => store.dispatch(new SetGoogleDriveFilesAction(files)),
        onSetCurrentUser: (user) => store.dispatch(new SetGoogleDriveUserAction(user)),
        onSignOut: () => store.dispatch(new GoogleDriveSignOutAction()),
        googleDriveState: store.state.googleDriveState
    );
  }
}
