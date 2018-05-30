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
import 'package:word_study/models/stored_file.dart';
import 'package:word_study/screens/file_downloader_screen.dart';
import 'package:word_study/screens/list_item_text_style.dart';

class FilesListScreen extends StatelessWidget {

  Widget _buildRow(BuildContext context, _ViewModel vm, int i) {
    return new Dismissible(
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
          StoredFile deletedFile = vm.files[i];
          bool canBeDeleted = vm.onRemove(vm.files[i]);

          if (canBeDeleted) {
            Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text(
                      WordStudyLocalizations.of(context).dismissed(
                          vm.files[i].name)
                  ),
                  duration: new Duration(seconds: 5),
                  action: new SnackBarAction(
                      label: WordStudyLocalizations
                          .of(context)
                          .undo,
                      onPressed: () {
                        vm.onUndoRemove(deletedFile);
                      }),
                )
            );
          }
          else {
            Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text(
                      WordStudyLocalizations.of(context).fileInUse
                  ),
                  duration: new Duration(seconds: 3)
                )
            );
            vm.reload();
          }
        },
        child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new ListTile(
                title: new Text(vm.files[i].name,
                    style: ListItemTextStyle.display5(context)),
                subtitle: new Text(vm.files[i].created.toString()),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(
                          builder: (context) {
                            if (vm.isEditing) {
                              vm.onEditQuiz(new Quiz(filenames: <String>[vm.files[i].name]));
                              return new EditQuiz();
                            }
                            return new CreateQuiz();
                          }
                      )
                  );
                  vm.onAddSelectedFile(vm.files[i].name);
                }
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        //TODO: Remove this, when multi-file select is supported
        store.dispatch(new ClearSelectedFilesAction());

        store.dispatch(new LoadFilesAction());
      },
      builder: (context, vm) {
        if (vm.isLoading) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text(WordStudyLocalizations.of(context).savedFiles),
            ),
            body: new Column(children: <Widget>[
              new Expanded(
                child: new Align(
                  alignment: Alignment.center,
                  child: new CircularProgressIndicator() ,
                ))
            ],)
          );
        }

        return new Scaffold(
          appBar: new AppBar(
          title: new Text(WordStudyLocalizations.of(context).savedFiles),
          ),
          body: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 2*vm.files.length,
            itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return new Divider();

            final index = position ~/ 2;

            return _buildRow(context, vm, index);
          }),
          floatingActionButton: new FloatingActionButton(
            heroTag: '__AddFileTag__',
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context) => new FileDownloaderScreen()
                  )
              );
            },
             child: new Icon(Icons.add)),
        );
      }
  );
  }
}

class _ViewModel {
  final List<StoredFile> files;
  final bool isLoading;
  final Function(String) onAddSelectedFile;
  final bool Function(StoredFile) onRemove;
  final Function(StoredFile) onUndoRemove;
  final Function(Quiz) onEditQuiz;
  final Function reload;
  final bool isEditing;

  _ViewModel({
    @required this.files,
    @required this.isLoading,
    @required this.onAddSelectedFile,
    @required this.onRemove,
    @required this.onUndoRemove,
    @required this.isEditing,
    @required this.onEditQuiz,
    @required this.reload
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      files: store.state.files,
      isLoading: store.state.isLoading,
      isEditing: store.state.selectedQuiz >= 0,
      onAddSelectedFile: (file) {
        print('adding ${file}');
        store.dispatch(new AddSelectedFileAction(file));
        store.dispatch(new CalculateTotalWordsCountAction());
      },
      onRemove: (file) {
        var filenames = store.state.quizzes.expand((q) => q.filenames);
        for(String f in filenames) {
          if (f == file.name) {
            return false;
          }
        }
        store.dispatch(new DeleteFileAction(file.name));
        return true;
      },
      onUndoRemove: (file) {
        store.dispatch(new RestoreFileAction(file));
      },
      onEditQuiz: (quiz) {
        store.dispatch(new EditQuizAction(quiz));
      },
      reload: () {
        store.dispatch(new LoadFilesAction());
      }
    );
  }
}