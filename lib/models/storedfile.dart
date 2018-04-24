import 'package:meta/meta.dart';

@immutable
class StoredFile {
  final String name;
  final DateTime created;

  StoredFile({this.name, this.created});

  StoredFile copyWith({String name, DateTime created}) {
    return new StoredFile(
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
          other is StoredFile &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              created == other.created;
}