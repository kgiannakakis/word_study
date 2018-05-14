import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/containers/create_quiz.dart';
import 'package:word_study/containers/edit_quiz.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/models/quiz.dart';
import 'package:word_study/screens/list_item_text_style.dart';
import 'package:word_study/screens/quiz_screen.dart';
import 'package:word_study/words/quiz_instance.dart';

class HomeScreen extends StatelessWidget {

  void _start(BuildContext context, Quiz quiz) async {
    QuizInstance quizInstance = new QuizInstance(quiz);
    bool ok = await quizInstance.init();
    if (ok) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) =>
              new QuizScreen(quizInstance: quizInstance, currentWord: 0)));
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
          content:
              new Text(WordStudyLocalizations.of(context).failedToStartQuiz),
          backgroundColor: Colors.redAccent));
    }
  }

  void _gotoCreateQuiz(BuildContext context, _ViewModel vm) async {
    vm.onClearSelectedFiles();
    Navigator
        .of(context)
        .push(new MaterialPageRoute(builder: (context) => new CreateQuiz()));
  }

  void _gotoEditQuiz(BuildContext context, Quiz quiz, _ViewModel vm) async {
    vm.onClearSelectedFiles();
    Navigator
        .of(context)
        .push(new MaterialPageRoute(builder: (context) => new EditQuiz(quiz: quiz,)));
  }

  Widget _buildRow(_ViewModel vm, int i, BuildContext context) {
    return new Dismissible(
        background: new Container(
          color: Colors.redAccent,
          padding: const EdgeInsets.all(12.0),
          child: new Align(
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

          Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text(WordStudyLocalizations
                    .of(context)
                    .dismissed(vm.quizzes[i].name)),
                duration: new Duration(seconds: 5),
                action: new SnackBarAction(
                    label: WordStudyLocalizations.of(context).undo,
                    onPressed: () {
                      vm.onUndoRemove(vm.quizzes[i]);
                    }),
              ));
        },
        child: new Container(
            decoration: new BoxDecoration(
                color:
                    i == vm.selectedQuiz ? Colors.black12 : Colors.transparent),
            child: new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new ListTile(
                  title: new Text(vm.quizzes[i].name,
                      style: ListItemTextStyle.display5(context)),
                  onTap: () {
                    vm.onSelectQuiz(-1);
                    _start(context, vm.quizzes[i]);
                  },
                  onLongPress: () {
                    if (vm.selectedQuiz == i) {
                      vm.onSelectQuiz(-1);
                    } else {
                      vm.onSelectQuiz(i);
                    }
                  },
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          if (vm.isLoading) {
            return new Scaffold(
                appBar: new AppBar(
                  title: new Text(WordStudyLocalizations.of(context).title),
                ),
                body: new Column(
                  children: <Widget>[
                    new Expanded(
                        child: new Align(
                      alignment: Alignment.center,
                      child: new CircularProgressIndicator(),
                    ))
                  ],
                ));
          }

          List<Widget> actions;
          if (vm.selectedQuiz >= 0) {
            actions = <Widget>[
//              new IconButton(
//                icon: new Icon(Icons.equalizer),
//                onPressed: () {},
//              ),
              new IconButton(
                icon: new Icon(Icons.edit),
                onPressed: () {
                  var selectedQuiz = vm.quizzes[vm.selectedQuiz];
                  vm.onSelectQuiz(-1);
                  _gotoEditQuiz(context, selectedQuiz, vm);
                },
              ),
            ];
          }

          return new Scaffold(
              appBar: new AppBar(
                title: new Text(WordStudyLocalizations.of(context).title),
                actions: actions,
              ),
              body: new Builder(builder: (BuildContext context) {
                return new ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: 2 * vm.quizzes.length,
                    itemBuilder: (BuildContext context, int position) {
                      if (position.isOdd) {
                        return new Divider(
                          height: 0.0,
                        );
                      }

                      final index = position ~/ 2;

                      return _buildRow(vm, index, context);
                    });
              }),
              floatingActionButton: new FloatingActionButton(
                  heroTag: '__AddQuizTag__',
                  onPressed: () {
                    vm.onSelectQuiz(-1);
                    _gotoCreateQuiz(context, vm);
                  },
                  child: new Icon(Icons.add)));
        });
  }
}

class _ViewModel {
  final List<Quiz> quizzes;
  final int selectedQuiz;
  final bool isLoading;
  final Function(Quiz) onRemove;
  final Function(Quiz) onUndoRemove;
  final Function onClearSelectedFiles;
  final Function(int) onSelectQuiz;

  _ViewModel(
      {@required this.quizzes,
      @required this.selectedQuiz,
      @required this.isLoading,
      @required this.onRemove,
      @required this.onUndoRemove,
      @required this.onClearSelectedFiles,
      @required this.onSelectQuiz});

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      quizzes: store.state.quizzes,
      selectedQuiz: store.state.selectedQuiz,
      isLoading: store.state.isLoading,
      onRemove: (quiz) {
        store.dispatch(new DeleteQuizAction(quiz.name));
      },
      onUndoRemove: (quiz) {
        store.dispatch(new AddQuizAction(quiz));
      },
      onClearSelectedFiles: () {
        store.dispatch(new ClearSelectedFilesAction());
      },
      onSelectQuiz: (i) {
        store.dispatch(new SelectQuizAction(i));
      },
    );
  }
}
