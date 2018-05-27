import 'package:flutter_test/flutter_test.dart';
import 'package:word_study/services/file_service.dart';

main() {
  group('File Service', () {
    test('should return correct name', () async {
      FileService fileService = const FileService();

      var filenames = <String>['name-1.xlsx', 'name-2.xlsx', 'name-3.xlsx'];
      String name = fileService.getNewFilenameFromFilelist(filenames, 'name.xlsx');
      print(name);
      assert(name == 'name-4.xlsx');

      filenames = <String>['name-1.xlsx', 'name-2.xlsx', 'name-3.xls'];
      name = fileService.getNewFilenameFromFilelist(filenames, 'name.xlsx');
      print(name);
      assert(name == 'name-3.xlsx');

      filenames = <String>['name-1', 'name-2', 'name-3'];
      name = fileService.getNewFilenameFromFilelist(filenames, 'name');
      print(name);
      assert(name == 'name-4');

      filenames = <String>['name-1.xlsx', 'name-2.xlsx', 'name-3.xlsx'];
      name = fileService.getNewFilenameFromFilelist(filenames, 'name-1.xlsx');
      print(name);
      assert(name == 'name-4.xlsx');

    });

  });
}
