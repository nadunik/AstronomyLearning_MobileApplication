class LiveEvent {
  final String title;
  final String description;
  final String eventUrl;
  final String imageUrl;

  LiveEvent({
    required this.title,
    required this.description,
    required this.eventUrl,
    required this.imageUrl,
  });

  factory LiveEvent.fromMap(Map<String, dynamic> map) {
    return LiveEvent(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      eventUrl: map['url'] ?? '',
      imageUrl: map['image'] ?? '',
    );
  }
}

