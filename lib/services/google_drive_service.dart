import 'dart:async';
import 'dart:convert' show json;
import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:word_study/words/web_wordprovider.dart';
import 'package:word_study/services/file_service.dart';
import 'package:word_study/models/google_drive_file.dart';
import 'package:word_study/models/google_drive_state.dart';

const String googleDriveAppFolderName = 'Word Study';

typedef onGoogleDriveUpdateState = void Function({GoogleDriveServiceMessage msg,
                                                  List<GoogleDriveFile> files});

typedef onGoogleDriveUserUpdated = void Function(GoogleSignInAccount user);

class GoogleDriveService {
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;

  onGoogleDriveUpdateState onUpdateState;
  onGoogleDriveUserUpdated onUpdateUser;

  void init() {
    _googleSignIn = new GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/drive.readonly'
      ],
    );

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
      onUpdateUser(_currentUser);
      if (_currentUser != null) {
        initGetFiles();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<Null> initGetFiles() async {
    onUpdateState(msg: GoogleDriveServiceMessage.loadingFiles, files: []);

    final String q = Uri.encodeComponent(
        'mimeType=\'application/vnd.google-apps.folder\' and name=\'Word Study\'');
    final http.Response response = await http.get(
      'https://www.googleapis.com/drive/v3/files?q=' + q,
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      onUpdateState(msg: GoogleDriveServiceMessage.folderNotFound);
      print('Google Drive API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['files'].length == 0) {
      onUpdateState(msg: GoogleDriveServiceMessage.folderFound);
    }
    else {
      getFilesList(data);
    }
  }

  Future<void> getFilesList(Map<String, dynamic> data) async {
    final String appFolder = _pickFirstFile(data);

    if (appFolder != null) {
      onUpdateState(msg: GoogleDriveServiceMessage.folderFound);
    } else {
      onUpdateState(msg: GoogleDriveServiceMessage.folderNotFound);
    }

    final Map<String, dynamic> folder0 = data['files'][0];
    final String q2 = Uri.encodeComponent('\'${folder0['id']}\' in parents and '
        'mimeType = \'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\'');
    final http.Response response = await http.get(
      'https://www.googleapis.com/drive/v3/files?q=' + q2,
      headers: await _currentUser.authHeaders,
    );
    final Map<String, dynamic> filesData = json.decode(response.body);

    if (filesData['files'].length == 0) {
      onUpdateState(msg: GoogleDriveServiceMessage.folderEmpty);
    }
    else {
      var files = <GoogleDriveFile>[];
      for(int i=0; i<filesData['files'].length; i++) {
        files.add(new GoogleDriveFile(filesData['files'][i]['name'],
            filesData['files'][i]['id']));
      }
      onUpdateState(files: files);
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

  Future<bool> downloadFile(GoogleDriveFile file) async {
    final FileService fileService = new FileService();

    var fileUrl = 'https://www.googleapis.com/drive/v3/files/${file.id}?alt=media';
    var headers = await _currentUser.authHeaders;

    var webWordProvider = new WebWordProvider(fileUrl, headers);
    bool ok = await webWordProvider.init();
    if (ok) {
      String filename = await fileService.getNewFilename(file.name);
      await webWordProvider.store(filename);
    }
    return ok;
  }

  Future<Null> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<Null> handleSignOut() async {
    _googleSignIn.disconnect();
  }
}