import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:astronomy_application/models/live_event_model.dart';

class LiveEventService {
  Future<List<LiveEvent>> fetchLiveEvents() async {
    final response = await http.get(Uri.parse('https://api.nasa.gov/planetary/apod?api_key=DfXvu7cAKroRI04SGLFv2dkDbl79jsvw4GMQnYkV'));

   if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [
        LiveEvent(
          title: data['title'] ?? '',
          description: data['explanation'] ?? '',
          eventUrl: data['url'] ?? '',
          imageUrl: data['url'] ?? '',
        ),
      ];
    } else {
      throw Exception('Failed to load live events');
    }
  }

  }

