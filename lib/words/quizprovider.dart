import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_study/words/quiz.dart';
import 'package:word_study/words/quizsettings.dart';

class QuizProvider {
  final String builtinFilename = '__builtin';
  final String _quizzesKey = 'quizzes';

  SharedPreferences _prefs;

  List<Quiz> _allQuizzes;
  List<Quiz> get allQuizzes {
    return _allQuizzes;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    String storedQuizzesStr = _prefs.getString(_quizzesKey);

    _allQuizzes = <Quiz>[];
    if (storedQuizzesStr == null) {
      _allQuizzes.add(_getDemoQuiz());
    }
    else {
      try {
        List<dynamic> ql = json.decode(storedQuizzesStr);
        ql.forEach((q) {
          _allQuizzes.add(Quiz.fromJson(q));
        });
      } catch(error) {
        _allQuizzes.add(_getDemoQuiz());
        print(error);
      }
    }
  }

  Quiz _getDemoQuiz() {
    const int wordsCount = 10;
    const int optionsCount = 4;
    QuizSettings quizSettings = new QuizSettings(
        wordsCount: wordsCount, optionsCount: optionsCount);
    Quiz builtin = new Quiz(
        name: "Demo", settings: quizSettings, filenames: [builtinFilename]);
    return builtin;
  }

  bool quizExists(String name) {
    return _allQuizzes.where((q) => q.name == name).length > 0;
  }

  Future<bool> addQuiz(Quiz quiz) async {
    List<Quiz> newAllQuizzes = <Quiz>[];
    _allQuizzes.forEach((q) => newAllQuizzes.add(q));
    newAllQuizzes.add(quiz);

    String allQuizzesStr = json.encode(newAllQuizzes);

    bool ok = await _prefs.setString(_quizzesKey, allQuizzesStr);

    if (ok) {
      _allQuizzes.add(quiz);
    }

    return ok;
  }

}