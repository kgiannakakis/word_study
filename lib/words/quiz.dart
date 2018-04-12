import 'dart:async';
import 'package:word_study/words/quizsettings.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/quizword.dart';

class Quiz {
  final QuizSettings settings;
  final WordProvider wordProvider;

  List<QuizWord> _quizWords;

  Quiz({this.settings, this.wordProvider});

  Future<bool> init() async {
    bool ok = await wordProvider.init();
    if (ok) {
      _quizWords = wordProvider.getWords(settings.wordsCount, settings.optionsCount);
    }
    return ok;
  }

  QuizWord getQuizWord(int index) {
    return _quizWords[index];
  }

}