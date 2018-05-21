import 'package:meta/meta.dart';
import 'package:word_study/models/dropbox_state.dart';
import 'package:word_study/models/google_drive_state.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/stored_file.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Quiz> quizzes;
  final int selectedQuiz;
  final Quiz quiz;
  final List<StoredFile> files;
  final List<String> selectedFiles;
  final int totalWordsCount;
  final GoogleDriveState googleDriveState;
  final DropboxState dropboxState;

  AppState({this.isLoading = false,
        this.quizzes = const [],
        this.selectedQuiz = -1,
        this.quiz,
        this.selectedFiles = const [],
        this.totalWordsCount = 0,
        this.files = const [],
        this.googleDriveState = const GoogleDriveState(),
        this.dropboxState = const DropboxState()});

  factory AppState.loading() => new AppState(isLoading: true);

  AppState copyWith({bool isLoading, List<Quiz> quizzes, int selectedQuiz,
    Quiz quiz, List<StoredFile> files, List<String> selectedFiles, int totalWordsCount,
    GoogleDriveState googleDriveState, DropboxState dropboxState}) {
    return new AppState(
        isLoading: isLoading ?? this.isLoading,
        quizzes: quizzes ?? this.quizzes,
        quiz: quiz ?? this.quiz,
        selectedQuiz: selectedQuiz ?? this.selectedQuiz,
        files: files ?? this.files,
        selectedFiles: selectedFiles ?? this.selectedFiles,
        totalWordsCount: totalWordsCount ?? this.totalWordsCount,
        googleDriveState: googleDriveState ?? this.googleDriveState,
        dropboxState: dropboxState ?? this.dropboxState);
  }

  @override
  int get hashCode => isLoading.hashCode ^ quizzes.hashCode ^ selectedQuiz.hashCode ^ quiz.hashCode ^
    selectedFiles.hashCode ^ totalWordsCount.hashCode ^ files.hashCode ^ googleDriveState.hashCode ^
    dropboxState.hashCode;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is AppState &&
      runtimeType == other.runtimeType &&
      isLoading == other.isLoading &&
      quiz == other.quiz &&
      quizzes == other.quizzes &&
      selectedQuiz == other.selectedQuiz &&
      files == other .files &&
      selectedFiles == other.selectedFiles &&
      totalWordsCount == other.totalWordsCount &&
      googleDriveState == other.googleDriveState &&
      dropboxState == other.dropboxState;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, quizzes: $quizzes}';
  }
}
