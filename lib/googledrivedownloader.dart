import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/drive.readonly'
  ],
);

const String googleDriveAppFolderName = 'Word Study';

class GoogleDriveDownloader extends StatefulWidget {
  @override
  State createState() => new GoogleDriveDownloaderState();
}

class GoogleDriveDownloaderState extends State<GoogleDriveDownloader> {
  GoogleSignInAccount _currentUser;
  String _messageText;

  @override
  void initState() {
    super.initState();
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
    });
    final String q = Uri.encodeComponent('mimeType=\'application/vnd.google-apps.folder\' and name=\'Word Study\'');
    print(q);
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
    print(response.body);
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
    print(response.body);
    final Map<String, dynamic> filesData = json.decode(response.body);

    if (filesData['files'].length == 0) {
      setState(() {
        _messageText = 'Folder is empty';
      });
    }
    else {
      final Map<String, dynamic> file0 = filesData['files'][0];

      print(file0['id']);

      var fileUrl = 'https://www.googleapis.com/drive/v3/files/${file0['id']}?alt=media';
      var headers = await _currentUser.authHeaders;
      final http.Response response3 = await http.get(fileUrl,
          headers: headers);
      var bytes = response3.bodyBytes;

      var decoder = new SpreadsheetDecoder.decodeBytes(bytes);
      var table = decoder.tables[decoder.tables.keys.first];
      for(int i=0; i<table.rows.length; i++) {
        var values = table.rows[i];
        print(values[0].toString() + ' = ' + values[1].toString());
      }
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
    if (_currentUser != null) {
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
    } else {
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
}
