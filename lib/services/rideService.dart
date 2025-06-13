import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class RideService {
  final String baseUrl = '${AppConstants.testUrl}/admin';

  Future<Map<String, dynamic>> fetchActiveRides() async {
    final url = Uri.parse('$baseUrl/rides');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'pool': data['rides']['pool'],
          'demand': data['rides']['demand'],
          'schedule': data['rides']['schedule'],
        };
      } else {
        throw Exception('Failed to load rides');
      }
    } catch (e) {
      throw Exception('Error fetching rides: $e');
    }
  }
}
