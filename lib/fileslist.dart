import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:word_study/quizsettingswidget.dart';

class FilesList extends StatefulWidget {

  @override
  FilesListState createState() => new FilesListState();
}

class FilesListState extends State<FilesList> {

  List<String> _files = <String>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();

    _loadFiles();
  }

  Future<List<FileSystemEntity>> _dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen (
            (file) => files.add(file),
        // should also register onError
        onDone:   () => completer.complete(files)
    );
    return completer.future;
  }


  Future<void> _loadFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    Directory dir = new Directory(directory.path);
    var fileSystemEntities = await _dirContents(dir);

    RegExp regexp = new RegExp('[^\/]+\$');

    List<String> files = <String>[];

    fileSystemEntities.forEach((f) {
      var match = regexp.firstMatch(f.path);
      files.add(match[0]);
    });

    setState(() {
      _files = files;
    });
  }

  void _create(int i) {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) => new QuizSettingsWidget(<String> [_files[i]])
        )
    );
  }

  Widget _buildRow(int i) {
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new ListTile(
            title: new Text(_files[i], style: _biggerFont),
            onTap: () { _create(i); }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Saved Files"),
      ),
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 2*_files.length,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return new Divider();

            final index = position ~/ 2;

            return _buildRow(index);
          }),
      floatingActionButton: new FloatingActionButton(onPressed: null,
          child: new Icon(Icons.add)),
    );
  }

}