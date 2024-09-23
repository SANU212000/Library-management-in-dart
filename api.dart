import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book.dart';
import 'author.dart';
import 'member.dart';
import 'library_management.dart';

class DataPersistence {
  final LibraryManager libraryManager;
  final String baseUrl = "https://crudcrud.com/api/6f46bd5499a542258ed785b744a4a9a8";  
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

  
  Future<void> postOrPutData(String endpoint, dynamic data, {bool isPut = false, String? id}) async {
    try {
      final uri = id != null 
        ? Uri.parse('$baseUrl/$endpoint/$id')
        : Uri.parse('$baseUrl/$endpoint');    // Use base endpoint for POST (create)
      
      final response = isPut
          ? await http.put(uri,
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

  // Save data to the API
  Future<void> saveData() async {
    try {
      for (var book in libraryManager.books) {
        await postOrPutData('books', book); // POST for new books
      }
      for (var author in libraryManager.authors) {
        await postOrPutData('authors', author); // POST for new authors
      }
      for (var member in libraryManager.members) {
        await postOrPutData('members', member); // POST for new members
      }
      print('Data saved successfully via API.');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Load data from the API
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
}
