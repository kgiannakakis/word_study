import 'package:word_study/words/quizsettings.dart';

class Quiz {
  final String name;
  final QuizSettings settings;
  final List<String> filenames;

  Quiz({this.name, this.settings, this.filenames});

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