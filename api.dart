import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book.dart';
import 'author.dart';
import 'member.dart';
import 'library_management.dart';

class DataPersistence {
  final LibraryManager libraryManager;
  final String baseUrl = "https://crudcrud.com/api/3043b4b282a1467d9ec2a3a09faf2eb8";  
  DataPersistence(this.libraryManager);


  Future<List<dynamic>> getData(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load data from $endpoint. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data from API: $e');
    }
  }

  
 Future<void> postOrPutData(String endpoint, dynamic data, {bool isPatch = false, String? id}) async {
  try {
    final uri = id != null 
      ? Uri.parse('$baseUrl/$endpoint/$id') 
      : Uri.parse('$baseUrl/$endpoint'); 

    final response = isPatch
        ? await http.patch(uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data))
        : await http.post(uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data));

    if (response.statusCode == 405) {
      throw Exception('Method not allowed for this endpoint: $endpoint. Check the HTTP method.');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save data to $endpoint. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error posting/putting data to API: $e');
  }
}



 Future<void> saveData() async {
  try {
    for (var book in libraryManager.books) {
      var existingBook = await getDataById('books', book.isbn); 
      if (existingBook != null) {
        await deleteData('books', existingBook['_id']); 
      }
      await postOrPutData('books', book); 
    }

    for (var author in libraryManager.authors) {
      var existingAuthor = await getDataById('authors', author.name);
      if (existingAuthor != null) {
        await deleteData('authors', existingAuthor['_id']);
      }
      await postOrPutData('authors', author); // 
    }

    for (var member in libraryManager.members) {
      var existingMember = await getDataById('members', member.memberId); 
      if (existingMember != null) {
        await deleteData('members', existingMember['_id']);
      }
      await postOrPutData('members', member); 
    }
    print('Data saved successfully via API.');
  } catch (e) {
    print('Error saving data: $e');
  }
}



  Future<void> loadData() async {
    try {
      var bookList = await getData('books');
      libraryManager.books = bookList.map((book) => Book.fromJson(book)).toList();

      var authorList = await getData('authors');
      libraryManager.authors = authorList.map((author) => Author.fromJson(author)).toList();

      var memberList = await getData('members');
      libraryManager.members = memberList.map((member) => Member.fromJson(member)).toList();

      print('Data loaded successfully from API.');
    } catch (e) {
      print('Error loading data: $e');
    }
  }


  Future<dynamic> getDataById(String endpoint, String identifier) async {
  try {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(response.body);

      for (var data in dataList) {
       
        if (endpoint == 'books' && data['isbn'] == identifier) {
          return data; 
        }
        
        else if (endpoint == 'authors' && data['name'] == identifier) {
          return data; 
        }
        
        else if (endpoint == 'members' && data['id'] == identifier) {
          return data;
        }
      }
      return null; 
    } else {
      throw Exception('Failed to load data from $endpoint. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching data from API: $e');
  }
}
Future<void> deleteData(String endpoint, String id) async {
  try {
    final uri = Uri.parse('$baseUrl/$endpoint/$id');
    final response = await http.delete(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete data from $endpoint. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error deleting data from API: $e');
  }
}

}



