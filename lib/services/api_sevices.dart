import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

// Class to manage API configurations
class ApiConfig {
  static const String baseUrl = 'https://api.openai.com/v1/completions';
  static const String model = "gpt-4o-mini"; // Default model
}

// Generic API POST request method
Future<Map<String, dynamic>?> apiPostRequest(
    String url, Map<String, dynamic> body) async {
  final apiKey ='';
      //"sk-kEn8On5PejAX2VgamPsgzoemPimZxNzHUvtUaky-AlT3BlbkFJgDZcILsIQELkckz60wYR8bhBmEm9HHa8k6tFtmflkA"; // Load API key from environment variable

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception: $e');
    return null;
  }
}

// Function to create a prompt for summarization
String createPrompt(String notes) {
  return "Summarize the following text in a clear and concise manner: $notes";
}

// Function to get a summary using OpenAI API
Future<String?> getSummary(String notes) async {
  final url = ApiConfig.baseUrl; // API endpoint
  final body = {
    "model": ApiConfig.model,
    "prompt": createPrompt(notes),
    "temperature": 0.5,
    "max_tokens": 150
  };

  try {
    final response = await apiPostRequest(url, body);
    if (response != null) {
      return response['choices'][0]['text'].trim();
    } else {
      return 'Failed to get a response from the API.';
    }
  } catch (e) {
    print('Error fetching summary: $e');
    return 'An unexpected error occurred. Please try again later.';
  }
}

// You can also define a separate class for handling other API-related functions
class ApiService {
  // Add other API-related methods here as needed
}
