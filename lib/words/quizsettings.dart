import 'package:meta/meta.dart';

@immutable
class QuizSettings {

  final int wordsCount;
  final int optionsCount;

  QuizSettings({this.wordsCount, this.optionsCount});

  QuizSettings copyWith({int wordsCount, int optionsCount}) {
    return new QuizSettings(
      wordsCount: wordsCount ?? this.wordsCount,
      optionsCount: optionsCount ?? this.optionsCount,
    );
  }

  @override
  int get hashCode =>
      wordsCount.hashCode ^ optionsCount.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is QuizSettings &&
              runtimeType == other.runtimeType &&
              wordsCount == other.wordsCount &&
              optionsCount == other.optionsCount;

  QuizSettings.fromJson(Map<String, dynamic> json)
      : wordsCount = json['wordsCount'],
        optionsCount = json['optionsCount'];

  Map<String, dynamic> toJson() =>
      {
        'wordsCount': wordsCount,
        'optionsCount': optionsCount,
      };

}