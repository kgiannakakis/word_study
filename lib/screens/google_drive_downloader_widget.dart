import 'package:meta/meta.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/services/google_drive_service.dart';
import 'package:word_study/models/google_drive_file.dart';
import 'package:word_study/screens/file_downloader_view_model.dart';
import 'package:word_study/models/google_drive_state.dart';

class GoogleDriveDownloader extends StatelessWidget {
  final FileDownloaderViewModel viewModel;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final GoogleDriveService googleDriveService = new GoogleDriveService();

  GoogleDriveDownloader({@required this.viewModel}) {
    googleDriveService.onUpdateState = onUpdateState;
    googleDriveService.onUpdateUser = onUpdateUser;
    googleDriveService.init();
  }

  void onUpdateUser(GoogleSignInAccount user) {
    viewModel.onSetCurrentUser(user);
  }

  void onUpdateState({GoogleDriveServiceMessage msg, List<GoogleDriveFile> files}) {
    if (msg != null) {
      viewModel.onSetMessage(msg);
    }
    if (files != null) {
      viewModel.onSetFiles(files);
    }
  }

  String _getMessageText(BuildContext context, GoogleDriveServiceMessage msg) {
    String m = '';
    if (msg != null) {
      switch (msg) {
        case GoogleDriveServiceMessage.starting:
          m = '';
          break;
        case GoogleDriveServiceMessage.failedToConnect:
          m = WordStudyLocalizations
              .of(context)
              .failedToConnectToGoogleDrive;
          break;
        case GoogleDriveServiceMessage.folderNotFound:
          m = WordStudyLocalizations.of(context).folderFound(
              googleDriveAppFolderName);
          break;
        case GoogleDriveServiceMessage.folderFound:
          m = WordStudyLocalizations.of(context).folderFound(
              googleDriveAppFolderName);
          break;
        case GoogleDriveServiceMessage.folderEmpty:
          m = WordStudyLocalizations
              .of(context)
              .folderIsEmpty;
          break;
        case GoogleDriveServiceMessage.loadingFiles:
          m = WordStudyLocalizations
              .of(context)
              .loadingFiles;
          break;
        case GoogleDriveServiceMessage.error:
          m = WordStudyLocalizations
              .of(context)
              .googleDriveError;
          break;
      }
    }
    return m;
  }

  Widget _buildBody(BuildContext context) {

    if (viewModel.googleDriveState.currentUser != null &&
        viewModel.googleDriveState.files.length == 0) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new ListTile(
            leading: new GoogleUserCircleAvatar(
              identity: viewModel.googleDriveState.currentUser,
            ),
            title: new Text(viewModel.googleDriveState.currentUser.displayName),
            subtitle: new Text(viewModel.googleDriveState.currentUser.email),
          ),
          new Text(WordStudyLocalizations.of(context).signedInSuccessfully),
          new Text(_getMessageText(context, viewModel.googleDriveState.message)),
          new RaisedButton(
            child: new Text(WordStudyLocalizations.of(context).signOut),
            onPressed: googleDriveService.handleSignOut,
          ),
          new RaisedButton(
            child: new Text(WordStudyLocalizations.of(context).refresh),
            onPressed: googleDriveService.initGetFiles,
          ),
        ],
      );
    }
    else if (viewModel.googleDriveState.currentUser != null &&
        viewModel.googleDriveState.files.length > 0) {
      return
        new Stack(
          children: <Widget>[
            new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 2*viewModel.googleDriveState.files.length,
                itemBuilder: (BuildContext context, int position) {
                  if (position.isOdd) return new Divider();

                  final index = position ~/ 2;

                  return _buildRow(context, index);
                }),
            new Align(
                alignment: new Alignment(0.0, 1.0),
                child: new Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    child: new Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: new Row(
                          children: <Widget>[
                            new RaisedButton(
                                onPressed: googleDriveService.handleSignOut,
                                child: new Text(WordStudyLocalizations.of(context).signOut)
                            ),
                            new Expanded( child:  new Text("")),
                            new RaisedButton(
                                onPressed: googleDriveService.initGetFiles,
                                child: new Text(WordStudyLocalizations.of(context).refresh)
                            )
                          ],
                        )
                    )
                )
            )
          ],
        );
    }
    else {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Padding(
              padding:const EdgeInsets.all(30.0),
              child:
              new Text(WordStudyLocalizations.of(context).googleDriveInstructions(googleDriveAppFolderName))
          ),
          new Text(WordStudyLocalizations.of(context).youAreNotCurrentlySignedIn),
          new RaisedButton(
            child: new Text(WordStudyLocalizations.of(context).signIn),
            onPressed: googleDriveService.handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(context),
      );
  }

  Widget _buildRow(BuildContext context, int i) {
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new ListTile(
            title: new Text(viewModel.googleDriveState.files[i].name, style: _biggerFont),
            onTap: () async {
              if ((await googleDriveService.downloadFile(viewModel.googleDriveState.files[i]))) {
                viewModel.onAddFile(new StoredFile(
                    name: viewModel.googleDriveState.files[i].name,
                    created: DateTime.now())
                );
                Navigator.of(context).pop();
              }
            }
        )
    );
  }
}
