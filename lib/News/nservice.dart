import 'dart:convert';
import 'package:http/http.dart' as http;
import 'nmodel.dart';

class NewsService {
  static const _apiKey = '1e5672f08ba74e61b350496e0e74334c';
  static const _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchTopHeadlines() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final articles = data['articles'] as List;
      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
