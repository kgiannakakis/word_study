import 'dart:async';
import 'package:flutter/material.dart';
import 'package:word_study/filedownloader.dart';
import 'package:word_study/files/fileservice.dart';
import 'package:word_study/files/wordfile.dart';
import 'package:word_study/words/filewordprovider.dart';

class FilesList extends StatefulWidget {

  @override
  FilesListState createState() => new FilesListState();
}

class FilesListState extends State<FilesList> {
  final FileService _fileService = new FileService();
  List<WordFile> _files = <WordFile>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();

    _loadFiles();
  }

  Future<void> _loadFiles() async {
    var files = await _fileService.listFiles();

    setState(() {
      _files = files;
    });
  }

  void _create(int i) async {
    var wordProvider = new FileWordProvider(_files[i].name);
    await wordProvider.init();

    Navigator.of(context).pop(<dynamic>[[_files[i].name], wordProvider.length]);
  }

  void _addNewFile() async {
    await Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) => new FileDownloader()
        )
    );
    await _loadFiles();
  }

  Widget _buildRow(int i) {
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new ListTile(
            title: new Text(_files[i].name, style: _biggerFont),
            subtitle: new Text(_files[i].created.toString()),
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
      floatingActionButton: new FloatingActionButton(
          onPressed: () { _addNewFile(); },
          child: new Icon(Icons.add)),
    );
  }

}