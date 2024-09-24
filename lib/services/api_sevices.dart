// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<String?> getSummary(String apiKey, String notes) async {
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
  final String apiKey = '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'; // Secure this key in production
  final String baseUrl = 'https://api.openai.com/v1/completionse'; // Update with your API URL

  Future<String> generateSummary(String notes) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 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',
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
//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