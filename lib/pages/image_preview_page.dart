import 'package:flutter/material.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const ImagePreviewPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 124, 40, 135),
        actions: [
          IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
              // TODO: Implement download logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Download feature coming soon!")),
              );
            },
              )
        ],
      ),
      /*body: Column(
        children: [
          Hero(
            tag: imageUrl,
            child: Expanded(
              child: InteractiveViewer(
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),*/
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: imageUrl,
              child: InteractiveViewer(
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
