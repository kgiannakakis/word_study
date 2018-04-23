import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:word_study/home.dart';
import 'package:word_study/models/appstate.dart';
import 'package:word_study/reducers/app_state_reducer.dart';
import 'package:word_study/middleware/store_quizzes_middleware.dart';
import 'package:word_study/actions/actions.dart';

void main() => runApp(new WordStudyApp());

class WordStudyApp extends StatelessWidget {

  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState.loading(),
    middleware: createStoreQuizzesMiddleware()
  );

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
                onInit: (store) => store.dispatch(new LoadQuizzesAction()),
                builder: (context, store) {
                  return new Home();
                })
        )
    );
  }
}



