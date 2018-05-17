
class CloudStorageFile {
  final String name;
  final String id;

  CloudStorageFile(this.name, this.id);

  @override
  int get hashCode =>
      name.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CloudStorageFile &&
        other.name == name &&
        other.id == id;
}