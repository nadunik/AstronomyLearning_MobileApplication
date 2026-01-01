
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:astronomy_application/models/image_model.dart';

class ImageService {
  Future<List<AstronomyImage>> fetchAstronomyImages() async {
    final apiKey = 'DEMO_KEY'; // Replace with your NASA API key
    final url = 'https://api.nasa.gov/planetary/apod?api_key=$apiKey&count=10';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => AstronomyImage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}

