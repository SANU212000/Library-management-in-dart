class Book {
  String title;
  String author;
  int publicationYear;
  String genre;
  String isbn;
  bool isLent;
   String? lentTo; 

  Book({
    required this.title,
    required this.author,
    required this.publicationYear,
    required this.genre,
    required this.isbn,
    this.isLent = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      publicationYear: json['publicationYear'],
      genre: json['genre'],
      isbn: json['isbn'],
      isLent: json['isLent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'publicationYear': publicationYear,
      'genre': genre,
      'isbn': isbn,
      'isLent': isLent,
    };
  }

  @override
  String toString() {
    return 'Book: $title, Author: $author, Year: $publicationYear, Genre: $genre, ISBN: $isbn, Lent: $isLent';
  }
}
