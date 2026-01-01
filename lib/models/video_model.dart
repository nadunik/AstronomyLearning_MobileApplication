class Video {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
  });

factory Video.fromJson(Map<String, dynamic> json) {
  final videoId = json['id']['videoId'];
  final videoUrl = 'https://www.youtube.com/watch?v=$videoId';

  return Video(
    id: videoId,
    title: json['snippet']['title'] ?? 'No Title',
    description: json['snippet']['description'] ?? '',
    videoUrl: videoUrl,
    thumbnailUrl: "https://img.youtube.com/vi/$videoId/0.jpg",
  );
}


 /* static String _extractYouTubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.first;
    } else if (uri.host.contains('youtube.com')) {
      return Uri.parse(url).queryParameters['v'] ?? '';
    }
    return '';
  }*/
}