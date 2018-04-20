import 'package:meta/meta.dart';
import 'dart:async';
import 'package:word_study/words/quizsettings.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/filewordprovider.dart';
import 'package:word_study/words/quizword.dart';

@immutable
class Quiz {
  final String name;
  final QuizSettings settings;
  final List<String> filenames;

  List<QuizWord> _quizWords;

  Quiz({this.name, this.settings, this.filenames});

  Future<bool> init() async {
    WordProvider wordProvider = new FileWordProvider(filenames[0]);
    bool ok = await wordProvider.init();
    if (ok) {
      _quizWords = wordProvider.getWords(settings.wordsCount, settings.optionsCount);
    }
    return ok;
  }

  QuizWord getQuizWord(int index) {
    return _quizWords[index];
  }

  Quiz.fromJson(Map<String, dynamic> jsonObject)
      : name = jsonObject['name'],
        settings = QuizSettings.fromJson(jsonObject['settings']),
        filenames = (jsonObject['filenames'] as List).cast<String>();

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'settings': settings.toJson(),
        'filenames': filenames
      };

}