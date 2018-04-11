import 'dart:io';
import 'dart:async';
import 'package:word_study/words/word.dart';
import 'package:word_study/words/quizword.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class WebWordProvider extends WordProvider {
  final String url;

  List<Word> _words = [];

  WebWordProvider(this.url);

  @override
  Future<bool> init() async {
    try {
      bool ok = await _readExcelFile(url);
      return ok;
    }
    catch(ex) {
      print(ex.toString());
      return false;
    }
  }

  Future<bool> _readExcelFile(String url) async {

    var httpClient = new HttpClient();
    var uri = Uri.parse(url);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();

    response.fold(new BytesBuilder(), (builder, data) => builder..add(data))
        .then((builder) {
      var data = builder.takeBytes();
      var decoder = new SpreadsheetDecoder.decodeBytes(data);
      var table = decoder.tables[decoder.tables.keys.first];
      for(int i=0; i<table.rows.length; i++) {
        var values = table.rows[i];
        _words.add(new Word(values[0].toString(), values[1].toString()));
        print(values);
      }
    });
    print("--------------------");
    return true;
  }

  @override
  QuizWord getWord(int optionsCount) {
    print("Getting word");
    return super.getWordFromList(_words, optionsCount);
  }
}