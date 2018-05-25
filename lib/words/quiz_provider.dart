import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:word_study/const/const.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/services/file_service.dart';
import 'package:word_study/words/word_provider.dart';

class QuizProvider {

  final String _quizzesKey = 'quizzes';
  final String _quizzesDb = 'quizzes.db';

  final FileService fileService;

  const QuizProvider(this.fileService);

  Future<Database> _openDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _quizzesDb);

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Quiz (id INTEGER PRIMARY KEY, name TEXT, wordsCount INTEGER, '
                  'optionsCount INTEGER, inverse INTEGER, filenames TEXT)');
        });
    return database;
  }

  Future<List<Quiz>> loadQuizzes() async {

    Database database = await _openDatabase();
    List<Map> list = await database.rawQuery('SELECT * FROM Quiz');

    if (list.length == 0) {
      final directory = await fileService.localPath;
      File file = new File('$directory/${Const.builtinFilename}');
      bool exists = await file.exists();

      if (!exists) {
        WordProvider wordProvider = new WordProvider();
        await wordProvider.init();
        await wordProvider.store(Const.builtinFilename);
      }

      return <Quiz>[_getDemoQuiz()];
    }
    else {
      List<Quiz> quizzes = new List<Quiz>();
      list.forEach((item) {
        QuizSettings settings = new QuizSettings(
          wordsCount: item['wordsCount'],
          optionsCount: item['optionsCount'],
          inverse: item['inverse'] > 0
        );
        Quiz quiz = new Quiz(
            id: item['id'],
            name: item['name'],
            settings: settings,
            filenames: item['filenames'].toString().split(','));
        quizzes.add(quiz);
      });
      return quizzes;
    }
  }

  Quiz _getDemoQuiz() {
    const int wordsCount = 10;
    const int optionsCount = 4;
    const bool inverse = false;
    QuizSettings quizSettings = new QuizSettings(
        wordsCount: wordsCount, optionsCount: optionsCount, inverse: inverse);
    Quiz builtin = new Quiz(
        name: "Demo", settings: quizSettings, filenames: [Const.builtinFilename]);
    return builtin;
  }

  Future<int> addQuiz(Quiz quiz) async {
    Database database = await _openDatabase();
    int id = await database.rawInsert(
        'INSERT INTO Quiz (name, wordsCount, optionsCount, inverse, filenames) '
            'VALUES (?, ?, ?, ?, ?)',
      [quiz.name, quiz.settings.wordsCount, quiz.settings.optionsCount,
       quiz.settings.inverse ? 1 : 0, quiz.filenames.join(',')]
    );
    return id;
  }

  Future<int> deleteQuiz(String name) async {
    Database database = await _openDatabase();
    return await database.rawDelete('DELETE FROM Quiz WHERE name=?', [name]);
  }

  Future<int> updateQuiz(Quiz quiz) async {
    Database database = await _openDatabase();

    return await database.rawUpdate(
        'UPDATE Quiz SET name=?, wordsCount=?, optionsCount=?, inverse=?, filenames=? '
        'WHERE id=?',
        [quiz.name, quiz.settings.wordsCount, quiz.settings.optionsCount,
         quiz.settings.inverse, quiz.filenames[0], quiz.id]);
  }

  Future<bool> saveQuizzes(List<Quiz> quizzes) async {
    String allQuizzesStr = json.encode(quizzes);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ok = await prefs.setString(_quizzesKey, allQuizzesStr);
    return ok;
  }

}