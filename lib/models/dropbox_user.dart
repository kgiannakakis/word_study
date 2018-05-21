class DropboxUser {
  final String displayName;
  final String email;

  DropboxUser({this.email, this.displayName});

  @override
  int get hashCode => email.hashCode ^ displayName.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DropboxUser&&
              other.email == email &&
              other.displayName == displayName;
}