import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ss_pool/constants.dart';

class DashboardService {
  static const String baseUrl =
      '${AppConstants.testUrl}/admin'; // Change to your API URL

  static Future<Map<String, dynamic>?> fetchTodayStats() async {
    final response = await http.get(Uri.parse('$baseUrl/stats/today'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> fetchYesterdayStats() async {
    final response = await http.get(Uri.parse('$baseUrl/stats/yesterday'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<List<dynamic>?> fetchMonthlyStats() async {
    final response = await http.get(Uri.parse('$baseUrl/stats/monthly'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<List<dynamic>?> fetchYearlyStats() async {
    final response = await http.get(Uri.parse('$baseUrl/stats/yearly'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // You can add more methods to fetch filtered stats etc.
}
