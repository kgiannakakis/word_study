
class GoogleDriveFile {
  final String name;
  final String id;

  GoogleDriveFile(this.name, this.id);

  @override
  int get hashCode =>
      name.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is GoogleDriveFile &&
        other.name == name &&
        other.id == id;
}