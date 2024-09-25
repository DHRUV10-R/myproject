// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> getSummary(String notes,) async {
  final apiKey = dotenv.env['OPENAI_API_KEY']; // Load API key from environment variable
  final url = Uri.parse('https://api.openai.com/v1/completions');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        "prompt": "Summarize the following text: $notes",
        "temperature": 0.5,
        "max_tokens": 150
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return 'An error occurred. Please try again.';
    }
  } catch (e) {
    print('Exception: $e');
    return 'An error occurred. Please check your network connection.';
  }
}

class ApiService {
  final String baseUrl = 'https://api.openai.com/v1/completions'; // Corrected API URL

  Future<String> generateSummary(String notes) async {
    final apiKey = dotenv.env['OPENAI_API_KEY']; // Load API key from environment variable

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
