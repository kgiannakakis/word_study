import 'dart:async';
import 'package:flutter/services.dart';

class DropBoxService {
  static const platform = const MethodChannel('gr.sullenart.wordstudy/dropbox');

  bool _started = false;

  Future<Null> init() async {
    _started = true;
    try {
      final String result = await platform.invokeMethod('startDropBoxAuth');
      print(result);
    } on PlatformException catch (e) {
      print('Failed to get dropbox access token: ${e.message}.');
      _started = false;
    }
  }
}