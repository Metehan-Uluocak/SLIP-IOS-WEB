import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/leak.dart';
import '../models/source.dart';
import '../models/platform.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5058/api';

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to load users');
  }

  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    throw Exception('Login failed');
  }

  static Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create user');
  }

  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  static Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  static Future<List<Leak>> getLeaks() async {
    final response = await http.get(Uri.parse('$baseUrl/leaks'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Leak.fromJson(json)).toList();
    }
    throw Exception('Failed to load leaks');
  }

  static Future<List<Source>> getSources() async {
    final response = await http.get(Uri.parse('$baseUrl/sources'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Source.fromJson(json)).toList();
    }
    throw Exception('Failed to load sources');
  }

  static Future<List<Platform>> getPlatforms() async {
    final response = await http.get(Uri.parse('$baseUrl/platforms'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Platform.fromJson(json)).toList();
    }
    throw Exception('Failed to load platforms');
  }

  // Source CRUD operations
  static Future<Source> createSource(Source source) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sources'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(source.toJson()),
    );
    if (response.statusCode == 201) {
      return Source.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create source');
  }

  static Future<void> updateSource(Source source) async {
    final response = await http.put(
      Uri.parse('$baseUrl/sources/${source.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(source.toJson()),
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to update source');
    }
  }

  static Future<void> deleteSource(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/sources/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete source');
    }
  }

  // Platform CRUD operations
  static Future<Platform> createPlatform(Platform platform) async {
    final response = await http.post(
      Uri.parse('$baseUrl/platforms'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(platform.toJson()),
    );
    if (response.statusCode == 201) {
      return Platform.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create platform');
  }

  static Future<void> updatePlatform(Platform platform) async {
    final response = await http.put(
      Uri.parse('$baseUrl/platforms/${platform.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(platform.toJson()),
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to update platform');
    }
  }

  static Future<void> deletePlatform(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/platforms/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete platform');
    }
  }
}
