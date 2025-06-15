import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../constants.dart';

class ProfileService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String?>> getProfileData() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return {
        'name': decodedToken['name'],
        'email': decodedToken['email'],
        'token': token,
      };
    }
    return {'name': null, 'email': null, 'token': null};
  }

  /// ✅ Function to create a new admin
  Future<String> createAdmin({
    required String name,
    required String email,
    required String password,
    required String gender,
  }) async {
    try {
      // Replace with your actual backend URL
      const String apiUrl = '${AppConstants.testUrl}/admin/create-admin';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'gender': gender,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['msg'] ?? 'Admin created';
      } else {
        return '❌ Failed to create admin. Status code: ${response.statusCode}';
      }
    } catch (e) {
      return '❌ Error creating admin: $e';
    }
  }
}
