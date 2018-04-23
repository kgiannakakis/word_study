import 'dart:async';

import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quizword.dart';
import 'package:word_study/words/wordprovider.dart';
import 'package:word_study/words/filewordprovider.dart';

class QuizInstance {
  final Quiz quiz;

  List<QuizWord> _quizWords;

  QuizInstance(this.quiz);

  Future<bool> init() async {
    WordProvider wordProvider = new FileWordProvider(quiz.filenames[0]);
    bool ok = await wordProvider.init();
    if (ok) {
      _quizWords = wordProvider.getWords(quiz.settings.wordsCount, quiz.settings.optionsCount);
    }
    return ok;
  }

  QuizWord getQuizWord(int index) {
    return _quizWords[index];
  }
}