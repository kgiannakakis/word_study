import 'package:meta/meta.dart';

@immutable
class WordFile {
  final String name;
  final DateTime created;

  WordFile({this.name, this.created});

  WordFile copyWith({String name, DateTime created}) {
    return new WordFile(
      name: name ?? this.name,
      created: created ?? this.created,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^ created.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WordFile &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              created == other.created;
}