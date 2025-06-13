import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';

class UserService {
  final String baseUrl = '${AppConstants.testUrl}/admin/users';

  Future<List<Map<String, dynamic>>> fetchUsers(String searchText) async {
    final uri = Uri.parse(
      searchText.isNotEmpty ? '$baseUrl?search=$searchText' : baseUrl,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List users = json.decode(response.body);
      return users.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load users');
    }
  }

  /// Fetch details of a single user by ID.
  Future<Map<String, dynamic>> fetchUserDetails(String id) async {
    final uri = Uri.parse('$baseUrl/$id');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user details');
    }
  }
}
