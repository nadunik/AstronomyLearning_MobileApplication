import 'package:flutter/material.dart';
import 'package:astronomy_application/models/video_model.dart';
import 'package:astronomy_application/pages/video_detail_page.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  const VideoTile({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final videoId = _getVideoId(video.videoUrl);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VideoDetailPage(video: video)),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'https://img.youtube.com/vi/$videoId/0.jpg',
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.broken_image, size: 50));
                },
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getVideoId(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['v'] ?? ''; 
  }
}