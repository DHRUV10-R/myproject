// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiKey = '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'; // Secure this key in production
  final String baseUrl = 'http://your_api_url_here/summarize'; // Update with your API URL

  Future<String> generateSummary(String notes) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({'text': notes}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['summary'];
      } else {
        throw Exception('Failed to generate summary');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
