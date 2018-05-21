import 'dart:async';
import 'dart:io';

import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:word_study/models/quiz_word.dart';
import 'package:word_study/models/word.dart';
import 'package:word_study/words/word_provider.dart';

class WebWordProvider extends WordProvider {
  final String url;
  final Map<String, String> headers;
  final bool isPost;

  List<Word> _words = [];

  WebWordProvider({this.url, this.headers, this.isPost});

  @override
  Future<bool> init() async {
    try {
      bool ok = await _readExcelFile(url);
      return ok;
    }
    catch(ex) {
      print('Error reading excel file: ${ex.toString()}');
      return false;
    }
  }

  Future<bool> _readExcelFile(String url) async {

    var httpClient = new HttpClient();
    var uri = Uri.parse(url);
    HttpClientRequest request;

    if (isPost == null || isPost == false) {
      request = await httpClient.getUrl(uri);
    }
    else {
      request = await httpClient.postUrl(uri);
    }


    if (headers != null) {
      headers.forEach((name, value) {
        request.headers.add(name, value);
      });
    }

    var response = await request.close();

    var builder = await response.fold(new BytesBuilder(), (builder, data) => builder..add(data));
    var data = builder.takeBytes();

    var decoder = new SpreadsheetDecoder.decodeBytes(data);
    var table = decoder.tables[decoder.tables.keys.first];
    for(int i=0; i<table.rows.length; i++) {
      var values = table.rows[i];
      _words.add(new Word(values[0].toString(), values[1].toString()));
    }

    return true;
  }

  @override
  QuizWord getWord(int optionsCount, bool inverse) {
    return super.getWordFromList(_words, optionsCount, inverse);
  }

  @override
  List<QuizWord> getWords(int wordsCount, int optionsCount, bool inverse) {
    return super.getWordsFromList(_words, wordsCount, optionsCount, inverse);
  }

  int get length {
    return _words.length;
  }

  Future<void> store (String filename) async {
    storeWords(_words, filename);
  }
}