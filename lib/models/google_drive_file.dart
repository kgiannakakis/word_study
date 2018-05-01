
class GoogleDriveFileWidget {
  final String name;
  final String id;

  GoogleDriveFileWidget(this.name, this.id);

  @override
  int get hashCode =>
      name.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is GoogleDriveFileWidget &&
        other.name == name &&
        other.id == id;
}