import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/models/cloud_storage_file.dart';
import 'package:word_study/models/cloud_storage_message.dart';
import 'package:word_study/models/cloud_storage_type.dart';
import 'package:word_study/screens/file_downloader_view_model.dart';
import 'package:word_study/services/dropbox_service.dart';

class DropBoxDownloader extends StatelessWidget {
  final FileDownloaderViewModel viewModel;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  DropBoxDownloader({@required this.viewModel});

  void onUpdateState({CloudStorageMessage msg, List<CloudStorageFile> files}) {
    if (msg != null) {
      viewModel.onSetMessage(CloudStorageType.Dropbox, msg);
    }
    if (files != null) {
      viewModel.onSetFiles(CloudStorageType.Dropbox, files);
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
              .failedToConnectToDropbox;
          break;
        case CloudStorageMessage.folderNotFound:
          m = WordStudyLocalizations.of(context).folderFound(
              dropboxAppFolderName);
          break;
        case CloudStorageMessage.folderFound:
          m = WordStudyLocalizations.of(context).folderFound(
              dropboxAppFolderName);
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
              .dropboxError;
          break;
      }
    }
    return m;
  }

  Widget _buildBody(BuildContext context) {
    if (viewModel.dropboxState.currentUser != null &&
        viewModel.dropboxState.files.length == 0) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new ListTile(
            title: new Text(viewModel.dropboxState.currentUser.displayName),
            subtitle: new Text(viewModel.dropboxState.currentUser.email),
          ),
          new Text(WordStudyLocalizations.of(context).signedInSuccessfully),
          new Text(_getMessageText(context, viewModel.dropboxState.message)),
          new RaisedButton(
            child: new Text(WordStudyLocalizations.of(context).signOut),
            onPressed: () => viewModel.onSignOut(CloudStorageType.Dropbox),
          ),
          new RaisedButton(
            child: new Text(WordStudyLocalizations.of(context).refresh),
            onPressed: () => viewModel.onRefreshFiles(CloudStorageType.Dropbox),
          ),
        ],
      );
    }
    else if (viewModel.dropboxState.currentUser != null &&
        viewModel.dropboxState.files.length > 0) {
      return
        new Stack(
          children: <Widget>[
            new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 2*viewModel.dropboxState.files.length,
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
                                onPressed: () => viewModel.onSignOut(CloudStorageType.Dropbox),
                                child: new Text(WordStudyLocalizations.of(context).signOut)
                            ),
                            new Expanded( child:  new Text("")),
                            new RaisedButton(
                                onPressed: () => viewModel.onRefreshFiles(CloudStorageType.Dropbox),
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
              new Text(WordStudyLocalizations.of(context).dropboxInstructions(dropboxAppFolderName))
          ),
          new Text(WordStudyLocalizations.of(context).youAreNotCurrentlySignedIn),
          new RaisedButton(
            child: new Text(WordStudyLocalizations.of(context).signIn),
            onPressed: () => viewModel.onSignIn(CloudStorageType.Dropbox),
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
            title: new Text(viewModel.dropboxState.files[i].name, style: _biggerFont),
            onTap: () async {
              viewModel.onDownloadFile(CloudStorageType.Dropbox,
                      viewModel.dropboxState.files[i],
                      () => _onDownloaded(context),
                      () => _onDownloadFailed(context));
            }
        )
    );
  }
}