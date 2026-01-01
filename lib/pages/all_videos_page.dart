import 'package:flutter/material.dart';
import 'package:astronomy_application/models/video_model.dart';
import 'package:astronomy_application/services/video_service.dart';
import 'package:astronomy_application/pages/video_detail_page.dart';

class AllVideosPage extends StatefulWidget {
  @override
  _AllVideosPageState createState() => _AllVideosPageState();
}

class _AllVideosPageState extends State<AllVideosPage> {
  Future<List<Video>>? futureVideos;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureVideos = VideoService().fetchVideos(); // default search keyword
  }

  void _searchVideos() {
    final keyword = _searchController.text.trim();
    setState(() {
      futureVideos = VideoService().fetchVideos(searchKeyword: keyword.isEmpty ? "space" : keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(257, 27, 0, 59),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Videos',
        style: TextStyle(color: Colors.white),),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _searchVideos(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search videos',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.deepPurple[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 27, 0, 59),
      body: FutureBuilder<List<Video>>(
        future: futureVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos available.', style: TextStyle(color: Colors.white70)));
          } else {
            final videos = snapshot.data!;
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Card(
                  color: Colors.deepPurple[700],
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        video.thumbnailUrl,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50, color: Colors.white30),
                      ),
                    ),
                    title: Text(
                      video.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      video.description,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoDetailPage(video: video),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


