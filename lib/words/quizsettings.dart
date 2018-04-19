
class QuizSettings {

  int wordsCount;
  int optionsCount;

  QuizSettings({this.wordsCount, this.optionsCount});

  QuizSettings.fromJson(Map<String, dynamic> json)
      : wordsCount = json['wordsCount'],
        optionsCount = json['optionsCount'];

  Map<String, dynamic> toJson() =>
      {
        'wordsCount': wordsCount,
        'optionsCount': optionsCount,
      };

}