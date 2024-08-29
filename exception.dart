
class BookNotFoundException implements Exception {
  final String message;
  BookNotFoundException(this.message);

  @override
  String toString() => 'BookNotFoundException: $message';
}

class AuthorNotFoundException implements Exception {
  final String message;
  AuthorNotFoundException(this.message);

  @override
  String toString() => 'AuthorNotFoundException: $message';
}

class MemberNotFoundException implements Exception {
  final String message;
  MemberNotFoundException(this.message);

  @override
  String toString() => 'MemberNotFoundException: $message';
}