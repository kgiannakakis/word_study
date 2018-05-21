import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/services.dart';
import "package:http/http.dart" as http;
import 'package:word_study/models/dropbox_user.dart';

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
      //onUpdateState(msg: CloudStorageMessage.folderNotFound);
      print('Dropbox API ${response.statusCode} response: ${response.body}');
      return null;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    String email = data['email'];
    String displayName = data['name']['display_name'];

    return new DropboxUser(email: email, displayName: displayName);
  }
}