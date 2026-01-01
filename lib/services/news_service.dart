import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

import '../models/news_model.dart';

class NewsService {
  final _url = "https://www.nasa.gov/rss/dyn/breaking_news.rss";

  Future<List<NewsArticle>> fetchNASAHeadlines() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final xml2json = Xml2Json();
      xml2json.parse(response.body);
      final jsonString = xml2json.toParker();

      final data = json.decode(jsonString);
      final items = data["rss"]["channel"]["item"] as List;

      return items.map((item) => NewsArticle(
        title: item["title"],
        description: item["description"],
        link: item["link"],
      )).toList();
    } else {
      throw Exception("Failed to load NASA news");
    }
  }
}
