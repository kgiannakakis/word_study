import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:redux/redux.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/middleware/middleware.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/models/quiz_settings.dart';
import 'package:word_study/reducers/app_state_reducer.dart';
import 'package:word_study/screens/home_screen.dart';

class MockWordStudyLocalizationsDelegate extends LocalizationsDelegate<WordStudyLocalizations> {
  const MockWordStudyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'el'].contains(locale.languageCode);

  @override
  Future<WordStudyLocalizations> load(Locale locale) {
    return new SynchronousFuture<WordStudyLocalizations>(new WordStudyLocalizations());
  }

  @override
  bool shouldReload(MockWordStudyLocalizationsDelegate old) => false;
}


class MockWordStudyApp extends StatelessWidget {

  final Store<AppState> store;

  MockWordStudyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        onGenerateTitle: (BuildContext context) => WordStudyLocalizations.of(context).title,
        localizationsDelegates: [
          const MockWordStudyLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          const FallbackMaterialLocalisationsDelegate()
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('el', ''),
        ],
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

    await tester.pumpWidget(new MockWordStudyApp(store));

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