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
    print('5. Search Option');
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
    print('16. Save Data');
    print('17. To Exit');
    print('\nEnter your choice:');

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
        search(libraryManager);
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
        print('Data saved.');
        break;
      case '17':
        print("exiting.....");
        return;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

// --------Book section-------------------------------------------------------------------->

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

  while (isbn.isEmpty || !RegExp(r'^\d+$').hasMatch(isbn)) {
    if (isbn.isEmpty) {
      print('ISBN is empty');
    } else {
      print('Invalid ISBN. Please enter numbers only.');
    }
    print('Please enter a valid ISBN:');
    isbn = stdin.readLineSync()!;
  

  print('Valid ISBN entered: $isbn');
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

    var book = libraryManager.getBookByISBN(isbn);
    if (book == null) {
      print('Book not found with the given ISBN.');
      return;
    }

    print('\nSelect option to update:');
    print('1. Update Title');
    print('2. Update Author');
    print('3. Update Publication Year');
    print('4. Update Genre');

    var choice = stdin.readLineSync()!;

    switch (choice) {
      case "1":
        print('Enter new book title:');
        var title = stdin.readLineSync()!;
        while (title == "") {
          print("Book name is requried");
          print('Enter book title:');
          title = stdin.readLineSync()!;
        }
        book.title = title;
        break;

      case '2':
        print('Enter new author name:');
        var author = stdin.readLineSync()!;
        while (author == "") {
          print('author name is required');
          print('enter new author name:');
          author = stdin.readLineSync()!;
        }
        book.author = author;
        break;

      case '3':
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
        book.publicationYear = publicationYear;
        break;

      case '4':
        print('Enter genre:');
        var genre = stdin.readLineSync()!;
        while (genre == "") {
          print('enter Genre:');
          genre = stdin.readLineSync()!;
        }
        book.genre = genre;
        break;

      default:
        print('Invalid option selected.');
        return;
    }

    libraryManager.updateBook(isbn, book);
  } catch (err) {
    print('Book not found.');
    print('Recheck ISBN.');
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

// -------------- Search section ---------------------------------------------------------------------->
void search(LibraryManager libraryManager) {
  print('\n Select option to Search:');
  print("\n1. Search by Book Title");
  print("2. Search by Book ISBN");
  print("3. Search by Author Name and there books");
  print("4. Search by Member Id (comming soon)");
  var choice = stdin.readLineSync()!;

  switch (choice) {
    case '1':
      searchBookByTitle(libraryManager);
      break;
    case '2':
      searchBookByIsbn(libraryManager);
      break;
    case "3":
      searchBookByAuthor(libraryManager);
      break;
    default:
      print('Invalid option selected.');
      return;
  }
}

void searchBookByIsbn(LibraryManager libraryManager) {
  print('Enter title of book to search:');
  try {
    var isbn = stdin.readLineSync()!;
    while (isbn == '') {
      print('check book isbn?');
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
    var name = stdin.readLineSync()!;
    while (name == '') {
      print('check book name?');
      print('try again:');
      name = stdin.readLineSync()!;
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

// ------------distrubuted section------------------------------------------------------------->

void lendBook(LibraryManager libraryManager) {
  print('Enter ISBN of book to lend:');
  var isbn = stdin.readLineSync()!;
  while (isbn == "")
  {
    print('please check ISBN');
    isbn = stdin.readLineSync()!;
  }
  print('Enter member ID:');
  var memberId = stdin.readLineSync()!;
  while (memberId == "")
  {
    print('please check Member ID');
    memberId = stdin.readLineSync()!;
  }

  libraryManager.lendBook(isbn, memberId);
}

void returnBook(LibraryManager libraryManager) {
  try {
    print('Enter ISBN of book to return:');
    var isbn = stdin.readLineSync()!;
    while (isbn == "")
    {
      print('please check ISBN');
      isbn = stdin.readLineSync()!;
    }

    print('Enter member ID:');
    var memberId = stdin.readLineSync()!;
    while (memberId == "")
    {
      print('please check Member ID');
      memberId = stdin.readLineSync()!;
    }

    libraryManager.returnBook(isbn, memberId);
  } catch (e) {
    print('check isbn:');
    print('$e');
  }
}

//------------------ Author section----------------------------------------------------------->


void addAuthor(LibraryManager libraryManager) {
  while (true) {
    try {
   
      print('Enter author name:');
      var name = stdin.readLineSync()!.trim();
      while (name.isEmpty) {
        print('Author name is empty. Please enter a valid author name:');
        name = stdin.readLineSync()!.trim();
      }

      
      DateTime? dateOfBirth;
      while (true) {
        try {
          print('Enter date of birth (yyyy-mm-dd):');
          dateOfBirth = DateTime.parse(stdin.readLineSync()!.trim());
          break; // 
        } catch (e) {
          print('Error: Invalid date format. Please enter in yyyy-mm-dd format.');
        }
      }

      var newAuthorId = Author.generateId(name, dateOfBirth!);

      
      var existingAuthor = libraryManager.authors.firstWhere(
        (author) => author.id == newAuthorId,
        orElse: () => emptyAuthor,
      );

      if (existingAuthor != emptyAuthor) {
        print(
            'Error: An author with the name "$name" and date of birth "${dateOfBirth.toIso8601String()}" already exists.');
        return;
      }

      
      print('Enter books written (comma separated):');
      var booksWritten = stdin.readLineSync()!
          .split(',')
          .map((book) => book.trim())
          .toList();


      var newAuthor = Author(
        name: name,
        dateOfBirth: dateOfBirth,
        booksWritten: booksWritten,
      );

      libraryManager.addAuthor(newAuthor);
      print('Author added successfully.');
      return;
    } catch (err) {
      print('Error: Invalid input or format. Please try again. $err');
      print('Ensure the date format is correct (yyyy-mm-dd).');
    }
  }
}


Author emptyAuthor = Author(
  name: '',
  dateOfBirth: DateTime(1900, 1, 1),
  booksWritten: [],
);

void updateAuthor(LibraryManager libraryManager) {
  
  print('Enter the name of the author to update:');
  var name = stdin.readLineSync()!;
  while (name.isEmpty) {
    print('Author name cannot be empty.');
    print('Enter the name of the author to update:');
    name = stdin.readLineSync()!;
  }

  
  var author = libraryManager.searchAuthorByName(name);
  if (author == null) {
    print('Author not found.');
    return;
  }

 
  print('What would you like to update?');
  print('1. Update Date of Birth');
  print('2. Update Books Written');
  var choice = stdin.readLineSync()!;

  DateTime? dateOfBirth;
  List<String>? booksWritten;

  switch (choice) {
    case '1':
     
      print('Enter new date of birth (yyyy-mm-dd):');
      var dateInput = stdin.readLineSync()!;
      while (dateInput.isEmpty || ! isValidDate(dateInput)) {
        print('Invalid or empty date. Please enter a valid date (yyyy-mm-dd):');
        dateInput = stdin.readLineSync()!;
      }
      dateOfBirth = DateTime.parse(dateInput);
      author.dateOfBirth = dateOfBirth;
      break;

    case '2':
      
      print('Enter new books written (comma separated):');
      var booksInput = stdin.readLineSync()!;
      booksWritten = booksInput.split(',').map((e) => e.trim()).toList();
      author.booksWritten = booksWritten;
      break;

    default:
      print('Invalid choice. Please try again.');
      return;
  }

  
  libraryManager.updateAuthor(name, author);
  print('Author updated successfully.');
}


bool isValidDate(String input) {
  try {
    DateTime.parse(input);
    return true;
  } catch (e) {
    return false;
  }
}

void deleteAuthor(LibraryManager libraryManager) {
  try {
    print('Enter name of author to delete:');
  var name = stdin.readLineSync()!;
  while (name == '') {
    print('error');
    print('enter name of author:');
    name = stdin.readLineSync()!;
  }
  libraryManager.deleteAuthor(name);
  } catch (e) {
    print('error occur,$e try again.');
    print('check name');
  }
  
}

//------------------ member section------------------------------------------------------------->
void addMember(LibraryManager libraryManager) {
  try {
    print('Enter member name:');
    var name = stdin.readLineSync()!;
    while (name.isEmpty) {
      print('Name cannot be empty. Please enter the name:');
      name = stdin.readLineSync()!;
    }

    
    print('Enter member ID:');
    var memberId = stdin.readLineSync()!;
    while (memberId.isEmpty || libraryManager.isMemberIdExists(memberId)) {
      if (memberId.isEmpty) {
        print('Member ID cannot be empty. Please enter a valid ID:');
      } else if (libraryManager.isMemberIdExists(memberId)) {
        print('Member ID already exists. Please enter a unique ID:');
      }
      memberId = stdin.readLineSync()!;
    }

    var member = Member(name: name, memberId: memberId);
    libraryManager.addMember(member);
  } catch (e) {
    print("An error occurred while adding the member. Please check the input.");
    print(e);
  }
}

bool isMemberIdExists(String memberId) {
  var members;
  return members.any((member) => member.memberId == memberId);
}

void updateMember(LibraryManager libraryManager) {
  try {
    print('Enter ID of member to update:');
    var memberId = stdin.readLineSync()!;
    while (memberId == '') {
      print('error');
      print('enter name of author:');
      memberId = stdin.readLineSync()!;
    }
    var member = libraryManager.searchMemberById(memberId);
    if (member == null) {
      print('Member not found.');
      return;
    }
    print("1. Update Name");
    print("2. Update Borrowed Books");
    print('Enter the option number for what you want to update:');
    var choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        print('Enter new name:');
        var name = stdin.readLineSync()!;
        while (name == '') {
          print('error');
          print('enter name of author:');
          name = stdin.readLineSync()!;
        }
        member.name = name;
        break;
      case '2':
        print('Enter new borrowed books (comma separated):');
        var borrowedBooks =
            stdin.readLineSync()!.split(',').map((e) => e.trim()).toList();
        member.borrowedBooks = borrowedBooks;
        break;

      default:
        print('Invalid option selected.');
        return;
    }
    libraryManager.updateMember(memberId, member);
    print('Member information updated successfully.');
  } catch (e) {
    print("Check everything you written is right");
    print(e);
  }
}

void deleteMember(LibraryManager libraryManager) {
  try {
    print('Enter ID of member to delete:');
    var memberId = stdin.readLineSync()!;

    while (memberId.isEmpty) {
      print('Error: Member ID cannot be empty.');
      print('Enter ID of member to delete:');
      memberId = stdin.readLineSync()!;
    }

   
    libraryManager.deleteMember(memberId);
  } catch (e) {
    print('$e, try again..');
  }
}
