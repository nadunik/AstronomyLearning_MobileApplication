import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EarthPage extends StatelessWidget {
  const EarthPage({Key? key}) : super(key: key);

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
                Stack(
                  children: [
                    Image.asset(
                      'images/earth_banner.jpg',
                      width: double.infinity,
                      height: 600,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 16,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        'Earth',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 10, color: Colors.black54, offset: Offset(2, 2))],
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                        child: const Text(
                          '''Earth is the third planet from the Sun and the only known place in the universe where life exists.

Fun facts:
- Earth is about 4.5 billion years old.
- 71% of Earth’s surface is covered in water.
- Earth has a protective atmosphere composed mostly of nitrogen and oxygen.
- The ozone layer shields the surface from harmful UV radiation.
- Earth’s gravity is perfect for sustaining a stable atmosphere and climate.

It rotates once every 24 hours and orbits the Sun every 365.25 days.''',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),

                    // Wikipedia Link
                      GestureDetector(
                        onTap: () {
                          _launchUrl('https://en.wikipedia.org/wiki/Earth');
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

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('images/earth_surface.png', fit: BoxFit.cover, height: 200, width: double.infinity),
                      ),
                      const SizedBox(height: 8),
                      const Text('Earth – the Blue Planet seen from space', style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 30),

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
                            _launchUrl('https://g.co/kgs/V1T5Evo');
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
