import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import 'package:word_study/words/word.dart';
import 'package:word_study/words/quizword.dart';
import 'package:word_study/words/wordprovider.dart';

class FileWordProvider extends WordProvider {
  final String filename;

  List<Word> _words = [];

  FileWordProvider(this.filename);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  @override
  Future<bool> init() async {
    try {
      final path = await _localPath;
      File file =  new File('$path/$filename');
      bool exists = await file.exists();
      if (!exists) {
        return false;
      }

      String contents = await file.readAsString();
      List<String> lines = contents.split('\n');
      lines.forEach((line) {
        List<String> values = line.split('\t');
        _words.add(new Word(values[0].toString(), values[1].toString()));
      });
      return true;
    }
    catch(ex) {
      print(ex.toString());
      return false;
    }
  }

  @override
  QuizWord getWord(int optionsCount) {
    return super.getWordFromList(_words, optionsCount);
  }

  @override
  List<QuizWord> getWords(int wordsCount, int optionsCount) {
    return super.getWords(wordsCount, optionsCount);
  }

  int get length {
    return _words.length;
  }

  Future<void> store (String filename) async {
    storeWords(_words, filename);
  }
}