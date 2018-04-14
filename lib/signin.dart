// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/drive.readonly'
  ],
);

//void main() {
//  runApp(
//    new MaterialApp(
//      title: 'Google Sign In',
//      home: new SignInDemo(),
//    ),
//  );
//}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => new SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<Null> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final String q = Uri.encodeComponent('mimeType=\'application/vnd.google-apps.folder\' and name=\'Word Study\'');
    print(q);
    final http.Response response = await http.get(
      'https://www.googleapis.com/drive/v3/files?q=' + q,
      //'?q=mimeType%3D%27application%2Fvnd.google-apps.folder%27+and+name=%27Word+Study%27',
      //'https://people.googleapis.com/v1/people/me/connections'
      //    '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    print(response.body);
    final Map<String, dynamic> data = json.decode(response.body);
    print(data['files'].length);
    final String namedContact = _pickFirstFile(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });

    final Map<String, dynamic> folder0 = data['files'][0];
    final String q2 = Uri.encodeComponent('\'${folder0['id']}\' in parents and '
    'mimeType = \'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\'');
    final http.Response response2 = await http.get(
      'https://www.googleapis.com/drive/v3/files?q=' + q2,
      headers: await _currentUser.authHeaders,
    );
    print('----------------');
    print(response2.body);
    final Map<String, dynamic> data2 = json.decode(response2.body);
    final Map<String, dynamic> file0 = data2['files'][0];

    print(file0['id']);

    var fileUrl = 'https://www.googleapis.com/drive/v3/files/${file0['id']}?alt=media';
    var headers = await _currentUser.authHeaders;
    final http.Response response3 = await http.get(fileUrl,
      headers: headers);
    var bytes = response3.bodyBytes;

//    var httpClient = new HttpClient();
//    var uri = Uri.parse(fileUrl);
//    var request = await httpClient.getUrl(uri);
//    headers.forEach((name, value) =>
//        request.headers.add(name, value)
//    );
//    var response3 = await request.close();
//
//    var builder = await response3.fold(new BytesBuilder(), (builder, data) => builder..add(data));
//    var bytes = builder.takeBytes();


    var decoder = new SpreadsheetDecoder.decodeBytes(bytes);
    var table = decoder.tables[decoder.tables.keys.first];
    for(int i=0; i<table.rows.length; i++) {
      var values = table.rows[i];
      print(values[0] + ' = ' + values[1]);
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

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
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
          new Text(_contactText),
          new RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          new RaisedButton(
            child: const Text('REFRESH'),
            onPressed: _handleGetContact,
          ),
        ],
      );
    } else {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
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
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Google Sign In'),
        ),
        body: new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
