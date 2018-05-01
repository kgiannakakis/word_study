import 'package:meta/meta.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/services/google_drive_service.dart';
import 'package:word_study/models/google_drive_file.dart';

class GoogleDriveDownloader extends StatefulWidget {
  final Function(StoredFile) onAddFile;

  GoogleDriveDownloader({ @required this.onAddFile});

  @override
  State createState() => new GoogleDriveDownloaderState(onAddFile: onAddFile);
}

class GoogleDriveDownloaderState extends State<GoogleDriveDownloader> {
  final Function(StoredFile) onAddFile;

  String _messageText = '';
  List<GoogleDriveFileWidget> _files = <GoogleDriveFileWidget>[];
  GoogleSignInAccount _currentUser;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final GoogleDriveService googleDriveService = new GoogleDriveService();

  GoogleDriveDownloaderState({@required this.onAddFile});

  void onUpdateUser(GoogleSignInAccount currentUser) {
    setState(() => _currentUser = currentUser);
  }

  void onUpdateState({GoogleDriveServiceMessage msg, List<GoogleDriveFileWidget> files}) {
    String m = null;
    if (msg != null) {
      switch (msg) {
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
      }
    }
    setState(() {
      if (m != null) {
        _messageText = m;
      }
      if (files != null) {
        _files = files;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    googleDriveService.onUpdateState = onUpdateState;
    googleDriveService.onUpdateUser = onUpdateUser;
    googleDriveService.init();
  }

  Widget _buildBody() {

    if (_currentUser != null && _files.length == 0) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new ListTile(
            leading: new GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: new Text(_currentUser.displayName),
            subtitle: new Text(_currentUser.email),
          ),
          new Text(WordStudyLocalizations.of(context).signedInSuccessfully),
          new Text(_messageText),
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
    else if (_currentUser != null && _files.length > 0) {
      return
        new Stack(
          children: <Widget>[
            new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 2*_files.length,
                itemBuilder: (BuildContext context, int position) {
                  if (position.isOdd) return new Divider();

                  final index = position ~/ 2;

                  return _buildRow(index);
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
        child: _buildBody(),
      );
  }

  Widget _buildRow(int i) {
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new ListTile(
            title: new Text(_files[i].name, style: _biggerFont),
            onTap: () async {
              if ((await googleDriveService.downloadFile(_files[i]))) {
                onAddFile(new StoredFile(name: _files[i].name, created: DateTime.now()));
                Navigator.of(context).pop();
              }
            }
        )
    );
  }
}
