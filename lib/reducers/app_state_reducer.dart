import 'package:word_study/models/appstate.dart';
import 'package:word_study/reducers/loading_reducer.dart';
import 'package:word_study/reducers/quizzes_reducer.dart';
import 'package:word_study/reducers/selected_files_reducer.dart';
import 'package:word_study/reducers/files_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    isLoading: loadingReducer(state.isLoading, action),
    quizzes: quizzesReducer(state.quizzes, action),
    selectedFiles: selectedFilesReducer(state.selectedFiles, action),
    files: filesReducer(state.files, action),
    totalWordsCount: totalWordsCountReducer(state.totalWordsCount, action),
  );
}
