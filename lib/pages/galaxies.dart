import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:astronomy_application/services/progress_service.dart';

class GalaxiesPage extends StatefulWidget {
  const GalaxiesPage({Key? key}) : super(key: key);

  @override
  State<GalaxiesPage> createState() => _GalaxiesPageState();
}

class _GalaxiesPageState extends State<GalaxiesPage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/galaxy.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    if (_isVideoInitialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
    } else {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color.fromARGB(255, 32, 6, 47)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Hero Banner
                Stack(
  children: [
    Image.asset(
      'images/galaxy_banner.jpg',
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    ),
    Positioned(
      top: 16,
      left: 8,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    Positioned(
      bottom: 20,
      left: 20,
      child: Text(
        'Galaxies',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 10,
              color: Colors.black54,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    ),
  ],
),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Content Section 1
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '''Galaxies consist of stars, planets, and vast clouds of gas and dust, all bound together by gravity. The largest contain trillions of stars and can be more than a million light-years across. The smallest can contain a few thousand stars and span just a few hundred light-years. Most large galaxies have supermassive black holes at their centers, some with billions of times the Sun’s mass.

Galaxies come in a variety of shapes, mostly spirals and ellipticals, as well as those with less orderly appearances, usually dubbed irregular.

Most galaxies are between 10 billion and 13.6 billion years old. Some are almost as old as the universe itself, which formed around 13.8 billion years ago. Astronomers think the youngest known galaxy formed approximately 500 million years ago.

Galaxies can organize into groups of about 100 or fewer members held together by their mutual gravity. Larger structures, called clusters, may contain thousands of galaxies. Groups and clusters can be arranged in superclusters, which are not gravitationally bound. Superclusters, empty voids, “walls” of galaxies, and other large-scale structures make up the cosmic web of matter in the universe.''',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Image with caption
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'images/Galaxy Andromeda.jpeg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Andromeda Galaxy - Our nearest large galactic neighbor',
                            style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Content Section 2
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '''Our home galaxy is called the Milky Way. It’s a spiral galaxy with a disk of stars spanning more than 100,000 light-years. Earth is located along one of the galaxy’s spiral arms, about halfway from the center. Our solar system takes about 240 million years to orbit the Milky Way just once.

From our perspective on Earth, the Milky Way looks like a faint, milky band of light arcing across the entire sky, which is how it got its name. This feature marks the central disk of our home galaxy seen edge on.

The Milky Way sits in a neighborhood with over 50 other galaxies called the Local Group. Its members range in size from dwarf galaxies (smaller galaxies with up to a few billion stars) to Andromeda, our nearest large galactic neighbor.

The Local Group sits just off the edge of the Virgo cluster and is part of the Laniakea supercluster.''',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Visual Tour of Galaxies',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),
                      _buildVideoPlayer(),

                      const SizedBox(height: 30),

                      Center(
                        child: Column(
                        children: [
                        ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/quiz');
        },
        icon: const Icon(Icons.quiz),
        label: const Text("Take a Quiz"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      const SizedBox(height: 16),

                      // Mark as Read Button
                       ElevatedButton.icon(
                          onPressed: () async {
                            await updateProgress("Galaxies", 100);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Progress updated!')),
                            );
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text("Mark as Read"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),]
                      ),

                      ),
                       const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

