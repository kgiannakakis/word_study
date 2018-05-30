import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:word_study/const/const.dart';
import 'package:word_study/models/stored_file.dart';

class FileService {

  const FileService();

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final String localPath = '${directory.path}/wordfiles';

    Directory dir = new Directory(localPath);
    if (!(await dir.exists())) {
      await dir.create();
    }

    return localPath;
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

    var fileSystemEntities = await _dirContents(dir);

    RegExp regexp = new RegExp('[^\/]+\$');

    List<StoredFile> files = <StoredFile>[];

    for(int i=0; i<fileSystemEntities.length; i++ ) {
      var f = fileSystemEntities[i];
      var stat = await f.stat();
      var match = regexp.firstMatch(f.path);
      var name = match[0];
      print(name);
      if (name != Const.builtinFilename) {
        files.add(new StoredFile(name: name, created: stat.modified));
      }
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
    var allFilenames = allFiles.map<String>((wordFile) => wordFile.name).toList();
    String newName = getNewFilenameFromFilelist(allFilenames, name);
    return newName;
  }

  String getNewFilenameFromFilelist(List<String> allFilenames, String name) {
    RegExp extRegexp = new RegExp('\\.([^\\.]+)\$');
    var extension = '';
    if (extRegexp.hasMatch(name)){
      var match = extRegexp.firstMatch(name);
      extension = match[1];
    }

    var basename = extension.length > 0 ?
      name.substring(0, name.length - 1 - extension.length) : name;

    RegExp regexp = new RegExp('-(\\d)+\$');
    int currentNumber = 0;
    if (regexp.hasMatch(basename)) {
      var match = regexp.firstMatch(basename);
      currentNumber = int.parse(match[1]);
      basename = basename.substring(0, basename.length - 1 - match[1].length);
    }

    var files = allFilenames.where((f) =>
      f.startsWith(basename) &&
          (extension.length == 0 || f.endsWith('.$extension')));

    int max = currentNumber;
    files.forEach((f) {
      if (extension.length > 0) {
        f = f.substring(0, f.length - 1 - extension.length);
      }
      if (regexp.hasMatch(f)) {
        var match = regexp.firstMatch(f);
        max = int.parse(match[1]);
      }
    });
    if (extension.length > 0) {
      
      return '$basename-${max + 1}.$extension';
    }
    return '$name-${max + 1}';
  }

  Future<bool> deleteFile(String filename) async {
    final directory = await localPath;
    final tempDirectory = await tempPath;

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