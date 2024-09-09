import 'book.dart';
import 'author.dart';
import 'main.dart';
import 'member.dart';
import 'dart:io';

class LibraryManager {
  List<Book> books = [];
  List<Author> authors = [];
  List<Member> members = [];

// ------------Book Section---------------------------------------------------------------=>

  void addBook(Book book) {
    if (books.any((b) => b.isbn == book.isbn)) {
      print('Error: A book with the ISBN ${book.isbn} already exists.');
      return;
    }

    var existingAuthor = authors.firstWhere(
      (a) => a.name == book.author,
      orElse: () => emptyAuthor,
    );

    if (existingAuthor == emptyAuthor) {
      DateTime dateOfBirth;
      while (true) {
        try {
          print(
              'Enter date of birth for the author ${book.author} (yyyy-mm-dd):');
          var input = stdin.readLineSync();
          dateOfBirth = DateTime.parse(input!);
          break;
        } catch (e) {
          print(
              'Invalid date format. Please enter the date in yyyy-mm-dd format.');
        }
      }
      var duplicateAuthor = authors.any((a) => a.dateOfBirth == dateOfBirth);
      if (duplicateAuthor) {
        print('Error: An author with the same date of birth already exists.');
        return;
      }

      var newAuthor = Author(
        name: book.author,
        dateOfBirth: dateOfBirth,
        booksWritten: [book.title],
      );
      authors.add(newAuthor);
      print('Author ${book.author} registered successfully.');
    } else {
      existingAuthor.booksWritten.add(book.title);
    }
    books.add(book);
    print('Book added successfully.');
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

  bool deleteBookByISBN(String isbn) {
    int initialCount = books.length;
    books.removeWhere((book) => book.isbn == isbn);
    return books.length < initialCount;
  }

// ------------Search Section-------------------------------------------------------------=>

  Author? searchAuthorByName(String name) {
    return authors.firstWhere((author) => author.name == name);
  }

  Member? searchMemberById(String memberId) {
    return members.firstWhere((member) => member.memberId == memberId);
  }

  Book? searchBookByTitle(String title) {
    return books.firstWhere((book) => book.title == title);
  }

  Book? getBookByISBN(String isbn) {
    return books.firstWhere((book) => book.isbn == isbn);
  }

  Book? searchBookByIsbn(String isbn) {
    return books.firstWhere((book) => book.isbn == isbn);
  }

  Author? searchBookByAuthor(String name) {
    return authors.firstWhere((Author) => Author.name == name);
  }

  Author? searchAuthorByAuthorId(String id) {
    return authors.firstWhere((Author) => Author.id == id);
  }
// ------------Distrubuted Section--------------------------------------------------------=>

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

//-------------Author Section-------------------------------------------------------------=>

  void addAuthor(Author author) {
    var existingAuthor = authors.firstWhere(
      (a) => a.id == author.id,
      orElse: () => emptyAuthor,
    );

    if (existingAuthor != emptyAuthor) {
      print(
          'Error: An author with the name "${author.name}" and date of birth "${author.dateOfBirth.toIso8601String()}" already exists.');
      return;
    }

    authors.add(author);
    print('Author $author is added successfully...');
    print('AuthorID is ${author.id}');
  }

  void viewAuthors() {
    if (authors.isEmpty) {
      print('No authors available.');
      return;
    }
    for (var author in authors) {
      print('Author ID: ${author.id}');
    print('Name: ${author.name}');
    print('Date of Birth: ${author.dateOfBirth}');
    print('Books Written: ${author.booksWritten.join(', ')}');
    print('------------------------------------');
    }
  }

 void updateAuthor(String authorId, Author updatedAuthor) {
  for (var author in authors) {
    if (author.id == authorId) {
      author.name = updatedAuthor.name;
      author.dateOfBirth = updatedAuthor.dateOfBirth;
      author.booksWritten = updatedAuthor.booksWritten;
      print('Author updated: ${author.name}');
      return;
    }
  }
  print('Author not found.');
}

  void deleteAuthor(String name) {
    bool authorExists = authors.any((author) => author.name == name);

    if (authorExists) {
      authors.removeWhere((author) => author.name == name);
      print('Author deleted.');
    } else {
      print('Error: Author not found.');
    }
  }

  bool isMemberIdExists(String memberId) {
    return members.any((member) => member.memberId == memberId);
  }

//-------------Member Section-------------------------------------------------------------=>

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
    bool memberExists = members.any((member) => member.memberId == memberId);

    if (memberExists) {
      members.removeWhere((member) => member.memberId == memberId);
      print('Member deleted.');
    } else {
      print('Error: Member not found.');
    }
  }
}
