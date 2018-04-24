import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:word_study/models/appstate.dart';
import 'package:word_study/actions/actions.dart';
import 'package:word_study/filedownloader.dart';
import 'package:word_study/models/storedfile.dart';
import 'package:word_study/words/filewordprovider.dart';

class FilesList extends StatelessWidget {

  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _create(BuildContext context, _ViewModel vm, int i) async {
    var wordProvider = new FileWordProvider(vm.files[i].name);
    await wordProvider.init();

    Navigator.of(context).pop(<dynamic>[[vm.files[i].name], wordProvider.length]);
  }

  void _addNewFile(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (context) => new FileDownloader()
      )
    );
  }

  Widget _buildRow(BuildContext context, _ViewModel vm, int i) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new ListTile(
        title: new Text(vm.files[i].name, style: _biggerFont),
        subtitle: new Text(vm.files[i].created.toString()),
        onTap: () { _create(context, vm, i); }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) => store.dispatch(new LoadFilesAction()),
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
            onPressed: () { _addNewFile(context); },
              child: new Icon(Icons.add)),
        );
      }
  );
  }
}

class _ViewModel {
  final List<StoredFile> files;
  final bool isLoading;

  _ViewModel({
    @required this.files,
    @required this.isLoading
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      files: store.state.files,
      isLoading: store.state.isLoading
    );
  }
}