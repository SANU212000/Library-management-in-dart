
  void addBook(Book book) {
    if (books.any((b) => b.isbn == book.isbn)) {
      print('Error: A book with the ISBN ${book.isbn} already exists.');
      return;
    }
    if (!authors.any((a) => a.name == book.author)) {
      var newAuthor = Author(
        name: book.author,
        dateOfBirth: DateTime.now(),
        booksWritten: [book.title],
      );
      authors.add(newAuthor);
      print('Author ${book.author} registered successfully.');
    } else {
      var existingAuthor = authors.firstWhere((a) => a.name == book.author);
      existingAuthor.booksWritten.add(book.title);
    }
    {
      books.add(book);
      print('Book added successfully.');
    }
  }