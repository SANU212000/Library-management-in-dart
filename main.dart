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
    print('5. Search Book by Title');
    print('6. Search Book by ISBN');
    print('7. Lend Book');
    print('8. Return Book');
    print('9. Add Author');
    print('10. View Authors');
    print('11. Update Author');
    print('12. Delete Author');
    print('13. Add Member');
    print('14. View Members');
    print('15. Update Member');
    print('16. Delete Member');
    print('17.Search Author and there books');
    print('17. Save Data');
    print('18. To Exit');
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
        searchBookByTitle(libraryManager);
        break;
      case '6':
        searchBookByIsbn(libraryManager);
        break;
      case '7':
        lendBook(libraryManager);
        break;
      case '8':
        returnBook(libraryManager);
        break;
      case '9':
        addAuthor(libraryManager);
        break;
      case '10':
        libraryManager.viewAuthors();
        break;
      case '11':
        updateAuthor(libraryManager);
        break;
      case '12':
        deleteAuthor(libraryManager);
        break;
      case '13':
        addMember(libraryManager);
        break;
      case '14':
        libraryManager.viewMembers();
        break;
      case '15':
        updateMember(libraryManager);
        break;
      case '16':
        deleteMember(libraryManager);
        break;
      case '17':
        searchBookByAuthor(libraryManager);
        break;
      case '18':
        await dataPersistence.saveData();
        print('Data saved.');
        break;
      case '19':
        print("exiting.....");
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
  while (genre == "") {
    print('Error:Genre is Empty');
    print('enter Genre:');
    genre = stdin.readLineSync()!;
  }

  print('Enter ISBN:');
  var isbn = stdin.readLineSync()!;
  while (isbn == "") {
    print('ISBN is empty');
    print('Please enter a ISBN:');

    isbn = stdin.readLineSync()!;
  }

  var book = Book(
      title: title,
      author: author,
      publicationYear: publicationYear,
      genre: genre,
      isbn: isbn);
  libraryManager.addBook(book);
}

void updateBook(LibraryManager libraryManager) {
  try {
    print('Enter ISBN of book to update:');
    var isbn = stdin.readLineSync()!;
    while (isbn == '') {
      print('ISBN is empty');
      print('Please enter a ISBN:');
      isbn = stdin.readLineSync()!;
    }

    print('Enter new book title:');
    var title = stdin.readLineSync()!;
    while (title == "") {
      print("Book name is requried");
      print('Enter book title:');
      title = stdin.readLineSync()!;
    }

    print('Enter new author name:');
    var author = stdin.readLineSync()!;
    while (author == "") {
      print('author name is required');
      print('enter new author name:');
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
        print('Please enter a valid 4-digit publication year.');
      }
    }

    print('Enter genre:');
    var genre = stdin.readLineSync()!;
    while (genre == "") {
      print('enter Genre:');
      genre = stdin.readLineSync()!;
    }

    var updatedBook = Book(
        title: title,
        author: author,
        publicationYear: publicationYear,
        genre: genre,
        isbn: isbn);
    libraryManager.updateBook(isbn, updatedBook);
  } catch (err) {
    print('book not found');
    print('check ISBN number');
  }
}

void deleteBook(LibraryManager libraryManager) {
  try {
    print('Enter ISBN of book to delete:');
    var isbn = stdin.readLineSync();
    while (isbn == null || isbn.isEmpty) {
      print("ISBN is wrong or not given. Please enter a valid ISBN:");
      isbn = stdin.readLineSync();
    }
    bool deleted = libraryManager.deleteBookByISBN(isbn);
    if (deleted) {
      print('Book deleted successfully.');
    } else {
      print('Book not found.');
    }
  } catch (err) {
    print('book not found $err');
    print('check ISBN number');
  }
}

void searchBookByTitle(LibraryManager libraryManager) {
  print('Enter title of book to search:');
  try {
    var title = stdin.readLineSync()!;
    while (title == '') {
      print('check book title?');
      print('try again:');
      title = stdin.readLineSync()!;
    }
    var book = libraryManager.searchBookByTitle(title);

    if (book != null) {
      print('Book found: ${book}');
    } else {
      print('Book not found.');
    }
  } catch (err) {
    print('book not found');
    print('try again');
  }
}
void searchBookByAuthor(LibraryManager libraryManager) {
  print('Enter author name to search:');
  try {
    var  name= stdin.readLineSync()!;
    while (name == '') {
      print('check book title?');
      print('try again:');
      name= stdin.readLineSync()!;
    }
    var authorName = libraryManager.searchBookByAuthor(name);

    if (authorName != null) {
      print('Book found: ${authorName}');
    } else {
      print('Book not found.');
    }
  } catch (err) {
    print('book not found');
    print('try again');
  }
}

void searchBookByIsbn(LibraryManager libraryManager) {
  print('Enter title of book to search:');
  try {
    var isbn = stdin.readLineSync()!;
    while (isbn == '') {
      print('check book title?');
      print('try again:');
      isbn = stdin.readLineSync()!;
    }
    var book = libraryManager.searchBookByIsbn(isbn);

    if (book != null) {
      print('Book found: ${book}');
    } else {
      print('Book not found.');
    }
  } catch (err) {
    print('book not found');
    print('try again');
  }
}

void lendBook(LibraryManager libraryManager) {
  print('Enter ISBN of book to lend:');
  var isbn = stdin.readLineSync()!;
  while (isbn == "");
  {
    print('please check ISBN');
    isbn = stdin.readLineSync()!;
  }
  print('Enter member ID:');
  var memberId = stdin.readLineSync()!;
  while (memberId == "");
  {
    print('please check Member ID');
    memberId = stdin.readLineSync()!;
  }

  libraryManager.lendBook(isbn, memberId);
}

void returnBook(LibraryManager libraryManager) {
  print('Enter ISBN of book to return:');

  var isbn = stdin.readLineSync()!;
  print('Enter member ID:');
  var memberId = stdin.readLineSync()!;

  libraryManager.returnBook(isbn, memberId);
}

void addAuthor(LibraryManager LibraryManager) {
  while (true) {
    try {
      print('Enter author name:');
      var name = stdin.readLineSync()!.trim();
      while (name == '') {
        print('Author name is empty. Please enter a valid author name:');
        name = stdin.readLineSync()!.trim();
      }

      print('Enter date of birth (yyyy-mm-dd):');
      var dateOfBirth = DateTime.parse(stdin.readLineSync()!.trim());
      while (dateOfBirth == '') {
        print('check dob');
        dateOfBirth = DateTime.parse(stdin.readLineSync()!.trim());
      }

      var newAuthorId = Author.generateId(name, dateOfBirth);

      

      // Check if an author with the generated ID already exists
      var existingAuthor = LibraryManager.authors.firstWhere(
        (author) => author.id == newAuthorId,
        orElse: () =>emptyAuthor,
    );

      if (existingAuthor != emptyAuthor) {
        print(
            'Error: An author with the name "$name" and date of birth "${dateOfBirth.toIso8601String()}" already exists.');
        return;
      }

      print('Enter books written (comma separated):');
      var booksWritten =
          stdin.readLineSync()!.split(',').map((e) => e.trim()).toList();

      // Create a new author with the generated unique ID
      var newAuthor = Author(
        name: name,
        dateOfBirth: dateOfBirth,
        booksWritten: booksWritten,
      );

      // Add the new author to the library
      LibraryManager.addAuthor(newAuthor);
      print('Author added successfully.');
      return;
    } catch (err) {
      print('Error: Invalid input or format. Please try again. $err');
      print('Ensure the date format is correct (yyyy-mm-dd).');
    }
  }
}
Author emptyAuthor = Author(
  name: '', // or some default value
  dateOfBirth: DateTime(1900, 1, 1), // or some default value
  booksWritten: [], // or some default value
);

void updateAuthor(LibraryManager libraryManager) {
  print('Enter name of author to update:');
  var name = stdin.readLineSync()!;

  while (name == '') {
    print('author is empty');
    print('name of author to update');
    name = stdin.readLineSync()!;
  }
  print('Enter new date of birth (yyyy-mm-dd):');
  var dateOfBirth = DateTime.parse(stdin.readLineSync()!);
  while (dateOfBirth == '') {
    print('DOB is empty');
    print('Enter new date of birth (yyyy-mm-dd):');
    dateOfBirth = DateTime.parse(stdin.readLineSync()!);
  }
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
