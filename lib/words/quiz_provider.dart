import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_study/services/file_service.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/words/word_provider.dart';

class QuizProvider {
  final String builtinFilename = '__builtin';
  final String _quizzesKey = 'quizzes';

  final FileService fileService;

  const QuizProvider(this.fileService);

  Future<List<Quiz>> loadQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedQuizzesStr = prefs.getString(_quizzesKey);

    if (storedQuizzesStr == null) {
      final directory = await fileService.localPath;
      File file = new File('$directory/$builtinFilename');
      bool exists = await file.exists();

      if (!exists) {
        WordProvider wordProvider = new WordProvider();
        await wordProvider.init();
        await wordProvider.store(builtinFilename);
      }

      return <Quiz>[_getDemoQuiz()];
    }
    else {
      List<Quiz> quizzes = new List<Quiz>();
      try {
        List<dynamic> ql = json.decode(storedQuizzesStr);
        ql.forEach((q) {
          quizzes.add(Quiz.fromJson(q));
        });
      } catch(error) {
        print(error);
      }
      return quizzes;
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

  Future<bool> saveQuizzes(List<Quiz> quizzes) async {
    String allQuizzesStr = json.encode(quizzes);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ok = await prefs.setString(_quizzesKey, allQuizzesStr);
    return ok;
  }

}