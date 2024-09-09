class Author {
  String id;
  String name;
  DateTime dateOfBirth;
  List<String> booksWritten;

  Author({
    required this.name,
    required this.dateOfBirth,
    this.booksWritten = const [],
  }) : id = generateId(name, dateOfBirth);

  static String generateId(String name, DateTime dob) {
    final base = '$name${dob.toIso8601String()}';
    final hash = base.codeUnits.fold(0, (prev, elem) => prev + elem);
    return hash.toString();
  }

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      booksWritten: List<String>.from(json['booksWritten']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'booksWritten': booksWritten,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Author && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Author: $name, DOB: ${dateOfBirth.toIso8601String()}, Books Written: ${booksWritten.join(', ')}';
  }
}
