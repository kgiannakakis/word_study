import 'package:meta/meta.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:word_study/models/quiz_settings.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Quiz> quizzes;
  final List<StoredFile> files;
  final List<String> selectedFiles;
  final int totalWordsCount;
  final QuizSettings quizSettings;
  final String quizName;

  AppState({this.isLoading = false,
        this.quizzes = const [],
        this.selectedFiles = const [],
        this.totalWordsCount = 0,
        this.quizSettings = const QuizSettings(wordsCount: 0, optionsCount: 4),
        this.files = const [],
        this.quizName});

  factory AppState.loading() => new AppState(isLoading: true);

  AppState copyWith({bool isLoading,
                     List<Quiz> quizzes,
                     List<StoredFile> files,
                     List<String> selectedFiles,
                     int totalWordsCount,
                     QuizSettings quizSettings,
                     String quizName}) {
    return new AppState(
        isLoading: isLoading ?? this.isLoading,
        quizzes: quizzes ?? this.quizzes,
        files: files ?? this.files,
        selectedFiles: selectedFiles ?? this.selectedFiles,
        totalWordsCount: totalWordsCount ?? this.totalWordsCount,
        quizSettings: quizSettings ?? this.quizSettings,
        quizName: quizName ?? this.quizName);
  }

  @override
  int get hashCode => isLoading.hashCode ^ quizzes.hashCode ^ totalWordsCount.hashCode ^
    quizName.hashCode ^ selectedFiles.hashCode ^ quizSettings.hashCode ^ files.hashCode;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is AppState &&
      runtimeType == other.runtimeType &&
      isLoading == (other as AppState).isLoading &&
      quizzes == (other as AppState).quizzes &&
      files == (other as AppState).files &&
      totalWordsCount == (other as AppState).totalWordsCount &&
      selectedFiles == (other as AppState).selectedFiles &&
      quizSettings == (other as AppState).quizSettings &&
      quizName == (other as AppState).quizName;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, quizzes: $quizzes}';
  }
}
