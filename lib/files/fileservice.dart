import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:word_study/files/wordfile.dart';

class FileService {

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

  Future<List<WordFile>> listFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    Directory dir = new Directory(directory.path);
    var fileSystemEntities = await _dirContents(dir);

    RegExp regexp = new RegExp('[^\/]+\$');

    List<WordFile> files = <WordFile>[];

    for(int i=0; i<fileSystemEntities.length; i++ ) {
      var f = fileSystemEntities[i];
      var stat = await f.stat();
      var match = regexp.firstMatch(f.path);
      files.add(new WordFile(match[0], stat.changed));
    }
    return files;
  }
}