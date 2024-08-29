import 'dart:convert';
import 'package:http/http.dart' as http;
import 'nmodel.dart';

class NewsService {
  Future<List<NewsArticle>> fetchTopHeadlines({String? category}) async {
    // Example API URL (replace with your actual API endpoint)
    String apiUrl = 'https://newsapi.org/v2/top-headlines?apiKey=1e5672f08ba74e61b350496e0e74334c';

    if (category != null && category.isNotEmpty) {
      apiUrl += '&category=$category';
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<NewsArticle> articles = (data['articles'] as List)
          .map((article) => NewsArticle.fromJson(article))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}





// static const _apiKey = '1e5672f08ba74e61b350496e0e74334c';
  // static const _baseUrl = 'https://newsapi.org/v2';