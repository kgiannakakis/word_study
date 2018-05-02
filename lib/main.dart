import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/middleware/middleware.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/reducers/app_state_reducer.dart';
import 'package:word_study/screens/home_screen.dart';

void main() => runApp(new WordStudyApp(new Store<AppState>(
    appReducer,
    initialState: new AppState.loading(),
    middleware: createMiddleware()
)));

class WordStudyApp extends StatelessWidget {

  final Store<AppState> store;

  WordStudyApp(this.store);

  @override
  Widget build(BuildContext context) {

    return new StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        onGenerateTitle: (BuildContext context) => WordStudyLocalizations.of(context).title,
        localizationsDelegates: [
          const WordStudyLocalizationsDelegate(),
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
          onInit: (store) => store.dispatch(new LoadQuizzesAction()),
          builder: (context, store) {
            return new HomeScreen();
          }
        )
      )
    );
  }
}



