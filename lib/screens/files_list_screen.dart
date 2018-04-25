import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/screens/file_downloader_screen.dart';
import 'package:word_study/models/stored_file.dart';

class FilesListScreen extends StatelessWidget {

  final _biggerFont = const TextStyle(fontSize: 18.0);

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
          vm.onRemove(vm.files[i]);

          Scaffold.of(context).showSnackBar(
              new SnackBar(
                content: new Text("${vm.files[i].name} dismissed"),
                duration: new Duration(seconds: 5),
                action: new SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      vm.onUndoRemove(vm.files[i]);
                    }),
              )
          );
        },
        child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new ListTile(
                title: new Text(vm.files[i].name, style: _biggerFont),
                subtitle: new Text(vm.files[i].created.toString()),
                onTap: () {
                  vm.onAddSelectedFile(vm.files[i].name);
                  Navigator.of(context).pop();
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
              title: new Text("Saved Files"),
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
          title: new Text("Saved Files"),
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
  final Function(StoredFile) onRemove;
  final Function(StoredFile) onUndoRemove;

  _ViewModel({
    @required this.files,
    @required this.isLoading,
    @required this.onAddSelectedFile,
    @required this.onRemove,
    @required this.onUndoRemove,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      files: store.state.files,
      isLoading: store.state.isLoading,
      onAddSelectedFile: (file) => store.dispatch(new AddSelectedFileAction(file)),
      onRemove: (file) {
        store.dispatch(new DeleteFileAction(file.name));
      },
      onUndoRemove: (file) {
        store.dispatch(new AddFileAction(file));
      },
    );
  }
}