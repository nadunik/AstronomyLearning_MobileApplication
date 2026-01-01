import 'package:flutter/material.dart';
import 'package:astronomy_application/models/news_model.dart';
import 'package:astronomy_application/services/news_service.dart';
import 'package:astronomy_application/widgets/news_tile.dart';
import 'package:astronomy_application/widgets/support_widget.dart';

class AllNewsPage extends StatefulWidget {
  const AllNewsPage({super.key});

  @override
  State<AllNewsPage> createState() => _AllNewsPageState();
}

class _AllNewsPageState extends State<AllNewsPage> {
  late Future<List<NewsArticle>> futureAllNews;

  @override
  void initState() {
    super.initState();
    futureAllNews = NewsService().fetchNASAHeadlines(); // Same service call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B003B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B003B),
        elevation: 0,
        title: Text('All NASA News', style: AppWidget.boldTextFieldStyle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<NewsArticle>>(
          future: futureAllNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No news available.'));
            } else {
              List<NewsArticle> newsList = snapshot.data!;
              return ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: NewsTile(news: newsList[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
