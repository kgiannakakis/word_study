import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:word_study/models/appstate.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/wordstudy.dart';
import 'package:word_study/quizsettingswidget.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/words/quizinstance.dart';

class Home extends StatelessWidget {

  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _start(BuildContext context, Quiz quiz) async {
    QuizInstance quizInstance = new QuizInstance(quiz);
    bool ok = await quizInstance.init();
    if (ok) {
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) => new WordStudy(quizInstance: quizInstance,
                currentWord: 0)
          )
      );
    }
    else {
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Failed to start quiz'),
          backgroundColor: Colors.redAccent
      ));
    }
  }

  void _gotoCreateQuiz(BuildContext context) async {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) => new QuizSettingsWidget()
        )
    );
  }

  Widget _buildRow(_ViewModel vm, int i, BuildContext context) {
    return
      new Dismissible(
        background: new Container(
          color: Colors.redAccent,
          padding: const EdgeInsets.all(12.0),
          child:new Align(
            child: new Icon(Icons.delete, color: Colors.white),
            alignment: Alignment.centerLeft,
          ),
        ),
        secondaryBackground: new Container(
          color: Colors.redAccent,
          padding: const EdgeInsets.all(12.0),
          child: new Align(
            child: new Icon(Icons.delete, color: Colors.white),
            alignment: Alignment.centerRight,
          ),
        ),
        key: new ObjectKey('quiz_$i'),
        onDismissed: (direction) {
          vm.onRemove(vm.quizzes[i]);

          Scaffold.of(context).showSnackBar(
            new SnackBar(
              content: new Text("${vm.quizzes[i].name} dismissed"),
              duration: new Duration(seconds: 5),
              action: new SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    vm.onUndoRemove(vm.quizzes[i]);
                  }),
            )
          );
        },
        child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new ListTile(
                title: new Text(vm.quizzes[i].name, style: _biggerFont),
                onTap: () { _start(context, vm.quizzes[i]); }
            )
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Word Study"),
          ),
          body: new Builder(
            builder: (BuildContext context) {
              return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 2 * vm.quizzes.length,
                itemBuilder: (BuildContext context, int position) {
                  if (position.isOdd) return new Divider();

                  final index = position ~/ 2;

                  return _buildRow(vm, index, context);
                });
              }
          ),
          floatingActionButton: new FloatingActionButton(
              onPressed: () => _gotoCreateQuiz(context),
              child: new Icon(Icons.add))
        );
      }
    );

  }
}

class _ViewModel {
  final List<Quiz> quizzes;
  final Function(Quiz) onRemove;
  final Function(Quiz) onUndoRemove;

  _ViewModel({
    @required this.quizzes,
    @required this.onRemove,
    @required this.onUndoRemove,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      quizzes: store.state.quizzes,
      onRemove: (quiz) {
        store.dispatch(new DeleteQuizAction(quiz.name));
      },
      onUndoRemove: (quiz) {
        store.dispatch(new AddQuizAction(quiz));
      },
    );
  }
}
