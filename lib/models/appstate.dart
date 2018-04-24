import 'package:meta/meta.dart';
import 'package:word_study/models/quiz.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Quiz> quizzes;
  final List<String> selectedFiles;
  final int totalWordsCount;

  AppState({this.isLoading = false,
        this.quizzes = const [],
        this.selectedFiles = const [],
        this.totalWordsCount = 0});

  factory AppState.loading() => new AppState(isLoading: true);

  AppState copyWith({bool isLoading, List<Quiz> quizzes, Quiz newQuiz, int totalWordsCount}) {
    return new AppState(
        isLoading: isLoading ?? this.isLoading,
        quizzes: quizzes ?? this.quizzes,
        selectedFiles: selectedFiles ?? this.selectedFiles,
        totalWordsCount: totalWordsCount ?? this.totalWordsCount);
  }

  @override
  int get hashCode => isLoading.hashCode ^ quizzes.hashCode ^
    selectedFiles.hashCode ^ totalWordsCount.hashCode;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is AppState &&
      runtimeType == other.runtimeType &&
      isLoading == (other as AppState).isLoading &&
      quizzes == (other as AppState).quizzes &&
      selectedFiles == (other as AppState).selectedFiles &&
      totalWordsCount == (other as AppState).totalWordsCount ;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, quizzes: $quizzes}';
  }
}
