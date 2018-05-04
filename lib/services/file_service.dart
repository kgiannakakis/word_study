import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:word_study/models/stored_file.dart';

class FileService {

  const FileService();

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return '${directory.path}/wordfiles';
  }

  Future<String> get tempPath async {
    final directory = await getTemporaryDirectory();

    return '${directory.path}';
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

  Future<List<StoredFile>> listFiles() async {
    final directory = await localPath;
    Directory dir = new Directory(directory);

    if (!(await dir.exists())) {
      await dir.create();
    }

    var fileSystemEntities = await _dirContents(dir);

    RegExp regexp = new RegExp('[^\/]+\$');

    List<StoredFile> files = <StoredFile>[];

    for(int i=0; i<fileSystemEntities.length; i++ ) {
      var f = fileSystemEntities[i];
      var stat = await f.stat();
      var match = regexp.firstMatch(f.path);
      files.add(new StoredFile(name: match[0], created: stat.modified));
    }
    return files;
  }

  Future<String> getNewFilename(String name) async {
    final directory = await localPath;
    File file = new File('$directory/$name');
    if (!(await file.exists())) {
      return name;
    }

    var allFiles = await listFiles();
    var allFilenames = allFiles.map<String>((wordFile) => wordFile.name);
    var files = allFilenames.where((f) => f.startsWith(name));

    RegExp regexp = new RegExp('-(\\d)+\$');
    int max = 0;
    files.forEach((f) {
      if (regexp.hasMatch(f)) {
        var match = regexp.firstMatch(f);
        max = int.parse(match[1]);
      }
    });

    return '$name-${max + 1}';
  }

  Future<bool> deleteFile(String filename) async {
    final directory = await localPath;
    final tempDirectory = await tempPath;

    print('$directory/$filename');
    File file = new File('$directory/$filename');
    if ((await file.exists())) {
      File tempFile = await file.copy('$tempDirectory/$filename');
      print('Copied deleted file to ${tempFile.path}');
      await file.delete();
      return true;
    }
    else {
      print('File $filename not found!');
      return false;
    }
  }

  Future<bool> undeleteFile(StoredFile storedFile) async {
    final directory = await localPath;
    final tempDirectory = await tempPath;

    File file = new File('$tempDirectory/${storedFile.name}');
    if ((await file.exists())) {
      File restoredFile = await file.copy('$directory/${storedFile.name}');
      await restoredFile.setLastModified(storedFile.created);
      print('Restored file ${restoredFile.path}');
      await file.delete();
      return true;
    }
    else {
      return false;
    }
  }
}