import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/models/cloud_storage_file.dart';
import 'package:word_study/models/cloud_storage_message.dart';
import 'package:word_study/models/cloud_storage_type.dart';
import 'package:word_study/screens/file_downloader_view_model.dart';
import 'package:word_study/screens/list_item_text_style.dart';
import 'package:word_study/services/google_drive_service.dart';

class GoogleDriveDownloader extends StatelessWidget {
  final FileDownloaderViewModel viewModel;

  GoogleDriveDownloader({@required this.viewModel});

  void onUpdateState({CloudStorageMessage msg, List<CloudStorageFile> files}) {
    if (msg != null) {
      viewModel.onSetMessage(CloudStorageType.GoogleDrive, msg);
    }
    if (files != null) {
      viewModel.onSetFiles(CloudStorageType.GoogleDrive, files);
    }
  }

  String _getMessageText(BuildContext context, CloudStorageMessage msg) {
    String m = '';
    if (msg != null) {
      switch (msg) {
        case CloudStorageMessage.starting:
          m = '';
          break;
        case CloudStorageMessage.failedToConnect:
          m = WordStudyLocalizations
              .of(context)
              .failedToConnectToGoogleDrive;
          break;
        case CloudStorageMessage.folderNotFound:
          m = WordStudyLocalizations.of(context).folderFound(
              googleDriveAppFolderName);
          break;
        case CloudStorageMessage.folderFound:
          m = WordStudyLocalizations.of(context).folderFound(
              googleDriveAppFolderName);
          break;
        case CloudStorageMessage.folderEmpty:
          m = WordStudyLocalizations
              .of(context)
              .folderIsEmpty;
          break;
        case CloudStorageMessage.loadingFiles:
          m = WordStudyLocalizations
              .of(context)
              .loadingFiles;
          break;
        case CloudStorageMessage.error:
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
            onPressed: () => viewModel.onSignOut(CloudStorageType.GoogleDrive),
          ),
          new RaisedButton(
            child: new Text(WordStudyLocalizations.of(context).refresh),
            onPressed: () => viewModel.onRefreshFiles(CloudStorageType.GoogleDrive),
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
                                onPressed: () => viewModel.onSignOut(CloudStorageType.GoogleDrive),
                                child: new Text(WordStudyLocalizations.of(context).signOut)
                            ),
                            new Expanded( child:  new Text("")),
                            new RaisedButton(
                                onPressed: () => viewModel.onRefreshFiles(CloudStorageType.GoogleDrive),
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
            onPressed: () => viewModel.onSignIn(CloudStorageType.GoogleDrive),
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

  void _onDownloaded(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onDownloadFailed(BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(WordStudyLocalizations.of(context).cantDownloadFile)
      )
    );
  }

  Widget _buildRow(BuildContext context, int i) {
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new ListTile(
            title: new Text(viewModel.googleDriveState.files[i].name,
                style: ListItemTextStyle.display5(context)),
            onTap: () async {
              viewModel.onDownloadFile(CloudStorageType.GoogleDrive,
                  viewModel.googleDriveState.files[i],
                  () => _onDownloaded(context),
                  () => _onDownloadFailed(context));
            }
        )
    );
  }
}
