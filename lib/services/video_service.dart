import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:astronomy_application/models/video_model.dart';

class VideoService {
  final String _apiKey = 'AIzaSyBlDhw8L737OcC2onmBWu00SRbTLvl0yw0'; // Replace with your YouTube API key
  final String _baseUrl = 'https://www.googleapis.com/youtube/v3/search';

  Future<List<Video>> fetchVideos({String searchKeyword = "space"}) async {
    final response = await http.get(Uri.parse(
      '$_baseUrl?part=snippet&q=$searchKeyword&type=video&key=$_apiKey'
    ));

    print('API Response: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['items'];
      return data.map((videoJson) => Video.fromJson(videoJson)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}

