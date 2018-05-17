import 'package:meta/meta.dart';
import 'package:word_study/models/quiz_settings.dart';

@immutable
class Quiz {
  final int id;
  final String name;
  final QuizSettings settings;
  final List<String> filenames;

  Quiz({this.id, this.name, this.settings, this.filenames});

  Quiz copyWith({int id, String name, QuizSettings settings, List<String> filenames}) {
    return new Quiz(
      id: id ?? this.id,
      name: name ?? this.name,
      settings: settings ?? this.settings,
      filenames: filenames ?? this.filenames,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ settings.hashCode ^ filenames.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Quiz &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              settings == other.settings &&
              filenames == other.filenames;

  Quiz.fromJson(Map<String, dynamic> jsonObject)
      : id = jsonObject['id'],
        name = jsonObject['name'],
        settings = QuizSettings.fromJson(jsonObject['settings']),
        filenames = (jsonObject['filenames'] as List).cast<String>();

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'settings': settings.toJson(),
        'filenames': filenames
      };

}