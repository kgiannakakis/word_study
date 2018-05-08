import 'dart:async';

import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_word.dart';
import 'package:word_study/words/word_provider.dart';
import 'package:word_study/words/file_word_provider.dart';

class QuizInstance {
  final Quiz quiz;

  List<QuizWord> _quizWords;

  QuizInstance(this.quiz);

  Future<bool> init() async {
    WordProvider wordProvider = new FileWordProvider(quiz.filenames[0]);
    bool ok = await wordProvider.init();
    if (ok) {
      _quizWords = wordProvider.getWords(quiz.settings.wordsCount,
          quiz.settings.optionsCount, quiz.settings.inverse ?? false);
    }
    return ok;
  }

  QuizWord getQuizWord(int index) {
    return _quizWords[index];
  }
}