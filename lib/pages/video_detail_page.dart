import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:astronomy_application/models/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final Video video;
  final List<Video>? relatedVideos; // optional related videos list

  const VideoDetailPage({
    Key? key,
    required this.video,
    this.relatedVideos,
  }) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.video.videoUrl) ?? "";
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    )..addListener(() {
        if (_controller.value.isReady && !_isPlayerReady) {
          setState(() {
            _isPlayerReady = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRelatedVideos() {
    final related = widget.relatedVideos;
    if (related == null || related.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.white38),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Related Videos",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: related.length,
            itemBuilder: (context, index) {
              final video = related[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoDetailPage(video: video, relatedVideos: related),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          video.thumbnailUrl,
                          height: 90,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        onReady: () => setState(() => _isPlayerReady = true),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(widget.video.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.fullscreen),
                onPressed: () => _controller.toggleFullScreenMode(),
              ),
            ],
          ),
          body: _isPlayerReady
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      player,
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.video.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          widget.video.description,
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildRelatedVideos(),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
        );
      },
    );
  }
}
