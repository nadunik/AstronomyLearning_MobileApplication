import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTile extends StatelessWidget {
  final NewsArticle news;

  NewsTile({required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(news.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(news.description, maxLines: 3, overflow: TextOverflow.ellipsis),
        onTap: () {
          // Open the article link
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Open Article'),
              content: Text('Do you want to read the full article?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    // Open the article link in a browser
                    launch(news.link); 
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}