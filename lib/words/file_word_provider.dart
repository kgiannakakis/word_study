import 'dart:io';
import 'dart:async';

import 'package:word_study/models/word.dart';
import 'package:word_study/models/quiz_word.dart';
import 'package:word_study/words/word_provider.dart';
import 'package:word_study/services/file_service.dart';

class FileWordProvider extends WordProvider {
  final String filename;
  final FileService _fileService = new FileService();

  List<Word> _words = [];

  FileWordProvider(this.filename);

  @override
  Future<bool> init() async {
    try {
      final path = await _fileService.localPath;
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