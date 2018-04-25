import 'package:redux/redux.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:word_study/models/app_state.dart';
import 'package:word_study/reducers/app_state_reducer.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/middleware/middleware.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/words/quiz_provider.dart';

class MockQuizzesService extends Mock implements QuizProvider {}

main() {
  group('Save State Middleware', () {
    test('should load the quizzes in response to a LoadQuizzesAction', () {
      final service = new MockQuizzesService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createMiddleware(),
      );
      final quizzes = [
        new Quiz(filenames: <String>['file1'],
            settings: new QuizSettings(wordsCount: 10, optionsCount: 4)),
      ];

      when(service.loadQuizzes()).thenReturn(new Future.value(quizzes));

      store.dispatch(new LoadQuizzesAction());

      verify(service.loadQuizzes());
    });

    test('should save the state on every update action', () {
      final service = new MockQuizzesService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createMiddleware(),
      );
      var quiz = new Quiz(filenames: <String>['file1'],
            settings: new QuizSettings(wordsCount: 10, optionsCount: 4));

      store.dispatch(new AddQuizAction(quiz));
      store.dispatch(new DeleteQuizAction('file1'));

      verify(service.saveQuizzes(any)).called(2);
    });
  });
}
