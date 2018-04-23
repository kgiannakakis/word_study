import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:word_study/state/appstate.dart';
import 'package:word_study/wordstudy.dart';
import 'package:word_study/quizsettingswidget.dart';
import 'package:word_study/words/quiz.dart';
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

  Widget _buildRow(List<Quiz> quizzes, int i, BuildContext context) {
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
//            List<Quiz> quizzes = new List<Quiz>();
//            for(int ii=0; ii<_quizzes.length; ii++) {
//              if (ii != i) {
//                quizzes.add(_quizzes[ii]);
//              }
//            }

//            Scaffold.of(context).showSnackBar(
//                new SnackBar(
//                    content: new Text("${quizzes[i].name} dismissed"),
//                    action: new SnackBarAction(label: 'Undo', onPressed: () {}),
//                )
//            );
          },
          child: new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new ListTile(
                  title: new Text(quizzes[i].name, style: _biggerFont),
                  onTap: () { _start(context, quizzes[i]); }
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

                  return _buildRow(vm.quizzes, index, context);
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
  //final Function(Quiz) onRemove;
  //final Function(Quiz) onUndoRemove;

  _ViewModel({
    @required this.quizzes,
    //@required this.onRemove,
    //@required this.onUndoRemove,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      quizzes: store.state.quizzes,
//      onRemove: (todo) {
//        store.dispatch(new DeleteTodoAction(todo.id));
//      },
//      onUndoRemove: (todo) {
//        store.dispatch(new AddTodoAction(todo));
//      },
    );
  }
}
