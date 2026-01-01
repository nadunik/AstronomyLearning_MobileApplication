import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MercuryPage extends StatelessWidget {
  const MercuryPage({Key? key}) : super(key: key);

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
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
                // Banner
                Stack(
                  children: [
                    Image.asset(
                      'images/mercury.jpg',
                      width: double.infinity,
                      height: 600,
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
                    const Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        'Mercury',
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
                      // Content Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '''Mercury is the smallest and innermost planet in the Solar System. It orbits the Sun once every 88 Earth days and has a very thin atmosphere. 

Here are some fun facts about Mercury:

- Mercury is only slightly larger than Earth's Moon.
- It’s the fastest planet, orbiting the Sun in just 88 days.
- Despite being closest to the Sun, it's not the hottest planet (Venus is).
- A day on Mercury (sunrise to sunrise) lasts 176 Earth days.
- It has no moons or rings.
- The surface is heavily cratered, resembling the Moon.

Mercury has extreme temperature changes, from 800°F (427°C) during the day to -290°F (-180°C) at night due to its lack of atmosphere to retain heat.''',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Wikipedia Link
                      GestureDetector(
                        onTap: () {
                          _launchUrl('https://en.wikipedia.org/wiki/Mercury_(planet)');
                        },
                        child: const Text(
                          'Read more on Wikipedia..',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'images/mercury_surface.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),

                      const SizedBox(height: 8),
                      const Text(
                        'Mercury’s cratered surface, captured by NASA',
                        style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                      ),

                      const SizedBox(height: 20),

                      // NASA Live Rotation Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 125, 55, 186),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.public, color: Colors.white,),
                          label: const Text(
                            'Interactive 3D Diagram (NASA)',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onPressed: () {
                            _launchUrl('https://g.co/kgs/J9nTJB6');
                          },
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


