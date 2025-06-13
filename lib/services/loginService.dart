import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginService {
  static const _storage = FlutterSecureStorage();

  static Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.testUrl}/admin/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          // Save token securely
          await _storage.write(key: 'auth_token', value: data['token']);
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${data['message']}')));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to login. Try again!')),
        );
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error occurred: $error')));
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      return true;
    } catch (error) {
      return false;
    }
  }
}
