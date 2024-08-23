// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../News/nmodel.dart';
import '../News/nservice.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsArticle>> _newsArticles;

  
  void initState() {
    super.initState();
    _newsArticles = NewsService().fetchTopHeadlines();
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _newsArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news found'));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: article.urlToImage.isNotEmpty
                      ? Image.network(article.urlToImage,
                          fit: BoxFit.cover, width: 100)
                      : null,
                  title: Text(article.title),
                  subtitle: Text(article.description),
                  onTap: () {
                    // Open the news article URL in a webview or browser
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
