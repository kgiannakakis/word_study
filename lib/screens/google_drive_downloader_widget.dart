import 'dart:async';
import 'dart:convert' show json;
import 'package:meta/meta.dart';
import 'package:word_study/models/stored_file.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/words/web_wordprovider.dart';
import 'package:word_study/files/file_service.dart';

const String googleDriveAppFolderName = 'Word Study';

class GoogleDriveFileWidget {
  final String name;
  final String id;

  GoogleDriveFileWidget(this.name, this.id);
}

class GoogleDriveDownloader extends StatefulWidget {
 final Function(StoredFile) onAddFile;

  GoogleDriveDownloader({ @required this.onAddFile});

  @override
  State createState() => new GoogleDriveDownloaderState(onAddFile: onAddFile);
}

class GoogleDriveDownloaderState extends State<GoogleDriveDownloader> {
  final Function(StoredFile) onAddFile;

  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;

  String _messageText;
  List<GoogleDriveFileWidget> _files = <GoogleDriveFileWidget>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final FileService _fileService = new FileService();

  GoogleDriveDownloaderState({@required this.onAddFile});

  @override
  void initState() {
    super.initState();

    _googleSignIn = new GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/drive.readonly'
      ],
    );

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _initGetFiles();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<Null> _initGetFiles() async {
    setState(() {
      _messageText = 'Loading files...';
      _files = [];
    });
    final String q = Uri.encodeComponent('mimeType=\'application/vnd.google-apps.folder\' and name=\'Word Study\'');
    final http.Response response = await http.get(
      'https://www.googleapis.com/drive/v3/files?q=' + q,
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _messageText = 'Failed to connect to Google Drive';
      });
      print('Google Drive API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['files'].length == 0) {
      setState(() {
        _messageText = '\'$googleDriveAppFolderName\' folder not found!';
      });
    }
    else {
      _getFilesList(data);
    }
  }

  Future<void> _getFilesList(Map<String, dynamic> data) async {
    final String appFolder = _pickFirstFile(data);

    setState(() {
      if (appFolder != null) {
        _messageText = '\'$appFolder\' folder found';
      } else {
        _messageText = '\'$googleDriveAppFolderName\' folder not found!';
      }
    });

    final Map<String, dynamic> folder0 = data['files'][0];
    final String q2 = Uri.encodeComponent('\'${folder0['id']}\' in parents and '
        'mimeType = \'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\'');
    final http.Response response = await http.get(
      'https://www.googleapis.com/drive/v3/files?q=' + q2,
      headers: await _currentUser.authHeaders,
    );
    final Map<String, dynamic> filesData = json.decode(response.body);

    if (filesData['files'].length == 0) {
      setState(() {
        _messageText = 'Folder is empty';
      });
    }
    else {
      var files = <GoogleDriveFileWidget>[];
      for(int i=0; i<filesData['files'].length; i++) {
        files.add(new GoogleDriveFileWidget(filesData['files'][i]['name'],
                                      filesData['files'][i]['id']));
      }
      setState(() {
        _files = files;
      });
    }
  }

  String _pickFirstFile(Map<String, dynamic> data) {
    final List<dynamic> files = data['files'];
    final Map<String, dynamic> file = files?.firstWhere(
          (dynamic contact) => contact['name'] != null,
      orElse: () => null,
    );
    if (file != null) {
      if (file != null) {
        return file['name'];
      }
    }
    return null;
  }

  Future<bool> _downloadFile(int i) async {
    GoogleDriveFileWidget file;
    file = _files[i];

    var fileUrl = 'https://www.googleapis.com/drive/v3/files/${file.id}?alt=media';
    var headers = await _currentUser.authHeaders;

    var webWordProvider = new WebWordProvider(fileUrl, headers);
    bool ok = await webWordProvider.init();
    if (ok) {
      String filename = await _fileService.getNewFilename(file.name);
      await webWordProvider.store(filename);
    }
    return ok;
  }

  Future<Null> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<Null> _handleSignOut() async {
    _googleSignIn.disconnect();
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
          const Text("Signed in successfully."),
          new Text(_messageText),
          new RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          new RaisedButton(
            child: const Text('REFRESH'),
            onPressed: _initGetFiles,
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
                            new RaisedButton(onPressed: _handleSignOut, child: new Text('SIGN OUT')),
                            new Expanded( child:  new Text("")),
                            new RaisedButton(onPressed: _initGetFiles, child: new Text('REFRESH'))
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
              const Text('Download files from your Google Drive. '
                  'Create a folder named \'$googleDriveAppFolderName\' and '
                  'upload your files there to discover them.')
          ),
          const Text('You are not currently signed in.'),
          new RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
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
              if ((await _downloadFile(i))) {
                onAddFile(new StoredFile(name: _files[i].name, created: DateTime.now()));
                Navigator.of(context).pop();
              }
            }
        )
    );
  }
}
