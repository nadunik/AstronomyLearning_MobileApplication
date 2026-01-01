import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<List<Map<String, dynamic>>> searchResults;

  @override
  void initState() {
    super.initState();
    searchResults = performSearch(widget.query);
  }

  Future<List<Map<String, dynamic>>> performSearch(String query) async {
    final lowerQuery = query.toLowerCase();
    final results = <Map<String, dynamic>>[];

    // NASA Image Library
    final imageResponse = await http.get(Uri.parse(
        'https://images-api.nasa.gov/search?q=$query&media_type=image'));
    if (imageResponse.statusCode == 200) {
      final data = json.decode(imageResponse.body);
      final items = data['collection']['items'] as List;
      for (var item in items) {
        final title = item['data'][0]['title'];
        final imageUrl = item['links'][0]['href'];
        if (title.toLowerCase().contains(lowerQuery)) {
          results.add({
            'type': 'Image',
            'title': title,
            'url': imageUrl,
          });
        }
      }
    }

    // NASA News via APOD (replace DEMO_KEY with your actual key)
    final newsResponse = await http.get(Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=DfXvu7cAKroRI04SGLFv2dkDbl79jsvw4GMQnYkV&count=10'));
    if (newsResponse.statusCode == 200) {
      final newsData = json.decode(newsResponse.body);
      for (var item in newsData) {
        final title = item['title'] ?? '';
        if (title.toLowerCase().contains(lowerQuery)) {
          results.add({
            'type': 'News',
            'title': title,
            'subtitle': item['explanation'] ?? '',
            'url': item['url'],
          });
        }
      }
    }

    return results;
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B003B),
      appBar: AppBar(
        title: Text('Results for "${widget.query}"'),
        backgroundColor: const Color.fromARGB(255, 100, 27, 152),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No results found.',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final results = snapshot.data!;

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return Card(
                color: const Color.fromARGB(255, 94, 68, 143),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text(item['title'],
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    item['type'] == 'News'
                        ? item['subtitle'] ?? ''
                        : item['type'],
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: item['url'] != null
                      ? const Icon(Icons.link, color: Colors.white)
                      : null,
                  onTap: item['url'] != null
                      ? () => _launchURL(item['url'])
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

