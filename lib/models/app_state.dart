import 'package:meta/meta.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:word_study/models/google_drive_state.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Quiz> quizzes;
  final List<StoredFile> files;
  final List<String> selectedFiles;
  final int totalWordsCount;
  final GoogleDriveState googleDriveState;

  AppState({this.isLoading = false,
        this.quizzes = const [],
        this.selectedFiles = const [],
        this.totalWordsCount = 0,
        this.files = const [],
        this.googleDriveState = const GoogleDriveState()});

  factory AppState.loading() => new AppState(isLoading: true);

  AppState copyWith({bool isLoading, List<Quiz> quizzes,
    List<StoredFile> files, List<String> selectedFiles, int totalWordsCount,
    GoogleDriveState googleDriveState}) {
    return new AppState(
        isLoading: isLoading ?? this.isLoading,
        quizzes: quizzes ?? this.quizzes,
        files: files ?? this.files,
        selectedFiles: selectedFiles ?? this.selectedFiles,
        totalWordsCount: totalWordsCount ?? this.totalWordsCount,
        googleDriveState: googleDriveState ?? this.googleDriveState);
  }

  @override
  int get hashCode => isLoading.hashCode ^ quizzes.hashCode ^
    selectedFiles.hashCode ^ totalWordsCount.hashCode ^ files.hashCode ^ googleDriveState.hashCode;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is AppState &&
      runtimeType == other.runtimeType &&
      isLoading == other.isLoading &&
      quizzes == other.quizzes &&
      files == other .files &&
      selectedFiles == other.selectedFiles &&
      totalWordsCount == other.totalWordsCount &&
      googleDriveState == other.googleDriveState;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, quizzes: $quizzes}';
  }
}
