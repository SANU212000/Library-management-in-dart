// ignore_for_file: unused_element

import 'book.dart';
import 'author.dart';
import 'member.dart';

class LibraryManager {
  List<Book> books = [];
  List<Author> authors = [];
  List<Member> members = [];

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

  void viewBooks() {
    if (books.isEmpty) {
      print('No books available.');
    } else {
      books.forEach((book) => print(book));
    }
  }

  void updateBook(String isbn, Book updatedBook) {
      bool bookFound = false;  

  for (var book in books) {
    if (book.isbn == isbn) {
     
      book.title = updatedBook.title;
      book.author = updatedBook.author;
      book.publicationYear = updatedBook.publicationYear;
      book.genre = updatedBook.genre;
      book.isbn = updatedBook.isbn;
      print('Book updated: ${book.title}');
      bookFound = true; 
      break; 
    }
  }

  if (!bookFound) {
    print('Book with ISBN $isbn not found.');
  }
}

  void deleteBook(String isbn) {
    books.removeWhere((book) => book.isbn == isbn);
    if (books == '') {
      print('book deleted');
    } else {
      print('Book not found.');
    }
  }

  Book? searchBookByTitle(String title) {
    return books.firstWhere((book) => book.title == title);
  }

  void lendBook(String isbn, String memberId) {
    var book = searchBookByIsbn(isbn);
    var member = searchMemberById(memberId);

    if (book == null) {
      print('Book not found.');
      return;
    }

    if (member == null) {
      print('Member not found.');
      return;
    }

    if (book.isLent) {
      print('Book is already lent.');
      return;
    }

    book.isLent = true;
    member.borrowedBooks.add(isbn);
    print('Book lent to member.');
  }

  void returnBook(String isbn, String memberId) {
    var book = searchBookByIsbn(isbn);
    var member = searchMemberById(memberId);

    if (book == null) {
      print('Book not found.');
      return;
    }

    if (member == null) {
      print('Member not found.');
      return;
    }

    if (!book.isLent) {
      print('Book is not lent.');
      return;
    }

    book.isLent = false;
    member.borrowedBooks.remove(isbn);
    print('Book returned.');
  }

  Book? searchBookByIsbn(String isbn) {
    return books.firstWhere((book) => book.isbn == isbn);
  }

  void addAuthor(Author author) {
    var existingAuthor = authors.firstWhere(
        (a) => a.name == author.name && a.dateOfBirth == author.dateOfBirth);

    print(
        'Error: An author with the name "${author.name}" and date of birth "${author.dateOfBirth.toIso8601String()}" already exists.');
    return;
  }

  void viewAuthors() {
    if (authors.isEmpty) {
      print('No authors available.');
      return;
    }
    for (var author in authors) {
      print(author);
    }
  }

  void updateAuthor(String name, Author updatedAuthor) {
    for (var author in authors) {
      if (author.name == name) {
        author.dateOfBirth = updatedAuthor.dateOfBirth;
        author.booksWritten = updatedAuthor.booksWritten;
        print('Author updated: ${author.name}');
        return;
      }
    }
    print('Author not found.');
  }

  void deleteAuthor(String name) {
    authors.removeWhere((author) => author.name == name);
    print('Author deleted.');
  }

  Author? searchAuthorByName(String name) {
    return authors.firstWhere((author) => author.name == name);
  }

  void addMember(Member member) {
    if (members.any((m) => m.memberId == member.memberId)) {
      print('Error: A member with ID ${member.memberId} already exists.');
    } else {
      members.add(member);
      print('Member added successfully.');
    }
  }

  void viewMembers() {
    if (members.isEmpty) {
      print('No members available.');
    } else {
      members.forEach((member) => print(member));
    }
  }

  void updateMember(String memberId, Member updatedMember) {
    for (var member in members) {
      if (member.memberId == memberId) {
        member.name = updatedMember.name;
        member.borrowedBooks = updatedMember.borrowedBooks;
        print('Member updated: ${member.name}');
        return;
      }
    }
    print('Member not found.');
  }

  void deleteMember(String memberId) {
    members.removeWhere((member) => member.memberId == memberId);
    print('Member deleted.');
  }

  Member? searchMemberById(String memberId) {
    return members.firstWhere((member) => member.memberId == memberId);
  }
}
