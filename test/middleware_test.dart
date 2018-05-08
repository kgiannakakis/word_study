import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/middleware/middleware.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/reducers/app_state_reducer.dart';
import 'package:word_study/words/quiz_provider.dart';

class MockQuizzesProvider extends Mock implements QuizProvider {}

main() {
  group('Save State Middleware', () {
    test('should load the quizzes in response to a LoadQuizzesAction', () {
      final provider = new MockQuizzesProvider();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createMiddleware(provider),
      );
      final quizzes = [
        new Quiz(filenames: <String>['file1'],
            settings: new QuizSettings(wordsCount: 10, optionsCount: 4, inverse: false)),
      ];

      when(provider.loadQuizzes()).thenReturn(new Future.value(quizzes));

      store.dispatch(new LoadQuizzesAction());

      verify(provider.loadQuizzes());
    });

    test('should save the state on every update action', () {
      final provider = new MockQuizzesProvider();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createMiddleware(provider),
      );
      var quiz = new Quiz(filenames: <String>['file1'],
            settings: new QuizSettings(wordsCount: 10, optionsCount: 4, inverse: false));

      when(provider.saveQuizzes(<Quiz>[])).thenReturn(new Future.value(true));
      when(provider.saveQuizzes(<Quiz>[quiz])).thenReturn(new Future.value(true));

      store.dispatch(new AddQuizAction(quiz));
      store.dispatch(new DeleteQuizAction('file1'));

      verify(provider.saveQuizzes(typed(any))).called(2);
    });
  });
}
