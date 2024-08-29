import 'dart:io';
import 'library_management.dart';
import 'data_persistence.dart';
import 'book.dart';
import 'author.dart';
import 'member.dart';

void main() async {
  var libraryManager = LibraryManager();
  var dataPersistence = DataPersistence(libraryManager);

  await dataPersistence.loadData();

  while (true) {
    print('\nLibrary Management System');
    print('1. Add Book');
    print('2. View Books');
    print('3. Update Book');
    print('4. Delete Book');
    print('5. Search Book');
    print('6. Lend Book');
    print('7. Return Book');
    print('8. Add Author');
    print('9. View Authors');
    print('10. Update Author');
    print('11. Delete Author');
    print('12. Add Member');
    print('13. View Members');
    print('14. Update Member');
    print('15. Delete Member');
    print('16. Save and Exit');
    print('Enter your choice:');

    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addBook(libraryManager);
        break;
      case '2':
        libraryManager.viewBooks();
        break;
      case '3':
        updateBook(libraryManager);
        break;
      case '4':
        deleteBook(libraryManager);
        break;
      case '5':
        searchBook(libraryManager);
        break;
      case '6':
        lendBook(libraryManager);
        break;
      case '7':
        returnBook(libraryManager);
        break;
      case '8':
        addAuthor(libraryManager);
        break;
      case '9':
        libraryManager.viewAuthors();
        break;
      case '10':
        updateAuthor(libraryManager);
        break;
      case '11':
        deleteAuthor(libraryManager);
        break;
      case '12':
        addMember(libraryManager);
        break;
      case '13':
        libraryManager.viewMembers();
        break;
      case '14':
        updateMember(libraryManager);
        break;
      case '15':
        deleteMember(libraryManager);
        break;
      case '16':
        await dataPersistence.saveData();
        print('Data saved. Exiting...');
        return;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

void addBook(LibraryManager libraryManager) {
  print('Enter book title:');
  var title = stdin.readLineSync()!;
  while (title.isEmpty) {
    print("Book name is requried");
    print('Enter book title:');
    title = stdin.readLineSync()!;
  }

  print('Enter author name:');
  var author = stdin.readLineSync()!;
  while (author == "") {
    print('author name is required');
    print('enter author name:');
    author = stdin.readLineSync()!;
  }

 int publicationYear;
  while (true) {
    print('Enter publication year:');
    var input = stdin.readLineSync()!;
    if (input.length == 4 && int.tryParse(input) != null) {
      publicationYear = int.parse(input);
      break;
    } else {
      print('Error: Please enter a valid 4-digit publication year.');
    }
  }                                      
  print('Enter genre:');
  var genre = stdin.readLineSync()!;
  print('Enter ISBN:');
  var isbn = stdin.readLineSync()!;

  var book = Book(
      title: title,
      author: author,
      publicationYear: publicationYear,
      genre: genre,
      isbn: isbn);
  libraryManager.addBook(book);
}

void updateBook(LibraryManager libraryManager) {
  print('Enter ISBN of book to update:');

  var isbn = stdin.readLineSync()!;
  print('Enter new book title:');
  var title = stdin.readLineSync()!;
  print('Enter new author name:');
  var author = stdin.readLineSync()!;
  print('Enter new publication year:');
  var publicationYear = int.parse(stdin.readLineSync()!);
  print('Enter new genre:');
  var genre = stdin.readLineSync()!;

  var updatedBook = Book(
      title: title,
      author: author,
      publicationYear: publicationYear,
      genre: genre,
      isbn: isbn);
  libraryManager.updateBook(isbn, updatedBook);
}

void deleteBook(LibraryManager libraryManager) {
  print('Enter ISBN of book to delete:');
  var isbn = stdin.readLineSync()!;
  libraryManager.deleteBook(isbn);
}

void searchBook(LibraryManager libraryManager) {
  print('Enter title of book to search:');
  var title = stdin.readLineSync()!;
  var book = libraryManager.searchBookByTitle(title);

  if (book != null) {
    print('Book found: ${book}');
  } else {
    print('Book not found.');
  }
}

void lendBook(LibraryManager libraryManager) {
  print('Enter ISBN of book to lend:');
  var isbn = stdin.readLineSync()!;
  print('Enter member ID:');
  var memberId = stdin.readLineSync()!;

  libraryManager.lendBook(isbn, memberId);
}

void returnBook(LibraryManager libraryManager) {
  print('Enter ISBN of book to return:');

  var isbn = stdin.readLineSync()!;
  print('Enter member ID:');
  var memberId = stdin.readLineSync()!;

  libraryManager.returnBook(isbn, memberId);
}

void addAuthor(LibraryManager libraryManager) {
  print('Enter author name:');
  var name = stdin.readLineSync()!;
  print('Enter date of birth (yyyy-mm-dd):');
  var dateOfBirth = DateTime.parse(stdin.readLineSync()!);
  print('Enter books written (comma separated):');
  var booksWritten =
      stdin.readLineSync()!.split(',').map((e) => e.trim()).toList();

  var author =
      Author(name: name, dateOfBirth: dateOfBirth, booksWritten: booksWritten);
  libraryManager.addAuthor(author);
}

void updateAuthor(LibraryManager libraryManager) {
  print('Enter name of author to update:');
  var name = stdin.readLineSync()!;
  print('Enter new date of birth (yyyy-mm-dd):');
  var dateOfBirth = DateTime.parse(stdin.readLineSync()!);
  print('Enter new books written (comma separated):');
  var booksWritten =
      stdin.readLineSync()!.split(',').map((e) => e.trim()).toList();

  var updatedAuthor =
      Author(name: name, dateOfBirth: dateOfBirth, booksWritten: booksWritten);
  libraryManager.updateAuthor(name, updatedAuthor);
}

void deleteAuthor(LibraryManager libraryManager) {
  print('Enter name of author to delete:');
  var name = stdin.readLineSync()!;
  libraryManager.deleteAuthor(name);
}

void addMember(LibraryManager libraryManager) {
  print('Enter member name:');
  var name = stdin.readLineSync()!;
  print('Enter member ID:');
  var memberId = stdin.readLineSync()!;

  var member = Member(name: name, memberId: memberId);
  libraryManager.addMember(member);
}

void updateMember(LibraryManager libraryManager) {
  print('Enter ID of member to update:');
  var memberId = stdin.readLineSync()!;
  print('Enter new name:');
  var name = stdin.readLineSync()!;
  print('Enter new borrowed books (comma separated):');
  var borrowedBooks =
      stdin.readLineSync()!.split(',').map((e) => e.trim()).toList();

  var updatedMember =
      Member(name: name, memberId: memberId, borrowedBooks: borrowedBooks);
  libraryManager.updateMember(memberId, updatedMember);
}

void deleteMember(LibraryManager libraryManager) {
  print('Enter ID of member to delete:');
  var memberId = stdin.readLineSync()!;
  libraryManager.deleteMember(memberId);
}
