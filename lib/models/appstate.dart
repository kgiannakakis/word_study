import 'package:meta/meta.dart';
import 'package:word_study/models/quiz.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Quiz> quizzes;

  AppState({this.isLoading = false,
    this.quizzes = const []});

  factory AppState.loading() => new AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    List<Quiz> quizzes,
  }) {
    return new AppState(
      isLoading: isLoading ?? this.isLoading,
      quizzes: quizzes ?? this.quizzes
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      quizzes.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              isLoading == (other as AppState).isLoading &&
              quizzes == (other as AppState).quizzes;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, quizzes: $quizzes}';
  }
}
