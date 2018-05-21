import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:word_study/models/cloud_storage_file.dart';
import 'package:word_study/models/dropbox_user.dart';
import 'package:word_study/services/file_service.dart';
import 'package:word_study/words/web_wordprovider.dart';

const String dropboxAppFolderName = 'Word Study';

class DropBoxService {
  static const platform = const MethodChannel('gr.sullenart.wordstudy/dropbox');

  bool _started = false;
  String _authToken;

  Future<DropboxUser> signIn() async {
    if (!_started) {
      _started = true;
      try {
        final String result = await platform.invokeMethod('startDropBoxAuth');
        _authToken = result;
        return await loadUserDetails();
      } on PlatformException catch (e) {
        print('Failed to get dropbox access token: ${e.message}.');
        _started = false;
        return null;
      }
    }
    else {
      return await loadUserDetails();
    }
  }

  Future<DropboxUser> loadUserDetails() async {
    final http.Response response = await http.post(
      'https://api.dropboxapi.com/2/users/get_current_account',
      headers: {'Authorization': 'Bearer ' + _authToken},
    );
    if (response.statusCode != 200) {
      print('Dropbox API ${response.statusCode} response: ${response.body}');
      return null;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    String email = data['email'];
    String displayName = data['name']['display_name'];

    return new DropboxUser(email: email, displayName: displayName);
  }

  Future<List<CloudStorageFile>> listFiles() async {
    String body =
    '{'
    '  "path": "",'
    '  "recursive": false,'
    '  "include_media_info": false,'
    '  "include_deleted": false,'
    '  "include_has_explicit_shared_members": false,'
    '  "include_mounted_folders": true'
    '}';

    final http.Response response = await http.post(
      'https://api.dropboxapi.com/2/files/list_folder',
      headers: {'Authorization': 'Bearer ' + _authToken,
                'Content-Type': 'application/json'},
      body: body
    );
    if (response.statusCode != 200) {
      print('Dropbox API ${response.statusCode} response: ${response.body}');
      return null;
    }
    final Map<String, dynamic> data = json.decode(response.body);

    var files = <CloudStorageFile>[];
    for(int i=0; i<data['entries'].length; i++) {
      files.add(new CloudStorageFile(data['entries'][i]['name'],
          data['entries'][i]['id']));
    }

    return files;
  }

  Future<bool> downloadFile(CloudStorageFile file) async {
    final FileService fileService = new FileService();

    var fileUrl = 'https://content.dropboxapi.com/2/files/download';
    var headers = {
      'Authorization': 'Bearer ' + _authToken,
      'Dropbox-API-Arg': '{"path": "${file.id}"}'
    };

    print(headers);

    var webWordProvider = new WebWordProvider(url: fileUrl, headers: headers, isPost: true);
    bool ok = await webWordProvider.init();
    if (ok) {
      String filename = await fileService.getNewFilename(file.name);
      print(filename);
      await webWordProvider.store(filename);
    }
    return ok;
  }

  void signOut() {
    _started = false;
  }
}