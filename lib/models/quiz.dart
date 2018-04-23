import 'package:meta/meta.dart';
import 'package:word_study/models/quizsettings.dart';

@immutable
class Quiz {
  final String name;
  final QuizSettings settings;
  final List<String> filenames;

  Quiz({this.name, this.settings, this.filenames});

  Quiz copyWith({String name, QuizSettings settings, List<String> filenames}) {
    return new Quiz(
      name: name ?? this.name,
      settings: settings ?? this.settings,
      filenames: filenames ?? this.filenames,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^ settings.hashCode ^ filenames.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Quiz &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              settings == other.settings &&
              filenames == other.filenames;

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