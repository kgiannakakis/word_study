import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:word_study/main.dart';
import 'package:word_study/middleware/middleware.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/reducers/app_state_reducer.dart';
import 'package:word_study/screens/home_screen.dart';


class MockWordStudyApp extends StatelessWidget {

  final Store<AppState> store;

  MockWordStudyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: store,
        child: new MaterialApp(
            title: 'Word Study',
            theme: new ThemeData(
              primarySwatch: Colors.green,
            ),
            home: new StoreBuilder<AppState>(
                builder: (context, store) {
                  return new HomeScreen();
                }
            )
        )
    );
  }
}

void main() {
  testWidgets('Home screen starts in loading mode', (WidgetTester tester) async {
    var store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createMiddleware()
    );

    await tester.pumpWidget(new WordStudyApp(store));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Home screen shows list of quizzes when loading is false', (WidgetTester tester) async {
    var quiz = new Quiz(filenames: <String>['file1'], name: 'My quiz',
        settings: new QuizSettings(wordsCount: 10, optionsCount: 4));
    List<Quiz> quizzes = [quiz];

    var store = new Store<AppState>(
        appReducer,
        initialState: new AppState(isLoading: false, quizzes: quizzes),
        middleware: createMiddleware()
    );


    await tester.pumpWidget(new MockWordStudyApp(store));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
  });
}