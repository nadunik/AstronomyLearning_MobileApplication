
class AstronomyImage {
  final String url;
  final String title;
  final String description;

  AstronomyImage({
    required this.url,
    required this.title,
    required this.description,
  });

  factory AstronomyImage.fromJson(Map<String, dynamic> json) {
    return AstronomyImage(
      url: json['url'] ?? '',
      title: json['title'] ?? 'Untitled',
      description: json['explanation'] ?? 'No description.',
    );
  }
} 