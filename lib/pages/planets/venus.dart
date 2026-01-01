import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VenusPage extends StatelessWidget {
  const VenusPage({Key? key}) : super(key: key);

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
                      'images/venus_banner.jpg',
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
                        'Venus',
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '''Venus is the second planet from the Sun and is similar in size and structure to Earth, which is why it's often called Earth’s twin.

Fun facts:
- Venus has a thick, toxic atmosphere mainly of carbon dioxide.
- It’s the hottest planet, with surface temperatures around 900°F (475°C).
- A day on Venus is longer than its year (243 Earth days vs. 225).
- It rotates in the opposite direction of most planets.
- The surface pressure is 92 times that of Earth’s – like being a mile underwater.

Despite its beauty, Venus is a hostile world.''',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Wikipedia Link
                      GestureDetector(
                        onTap: () {
                          _launchUrl('https://en.wikipedia.org/wiki/Venus');
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
                        child: Image.asset(
                          'images/venus_surface.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Venus surface from radar imaging',
                        style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                      ),
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
                            _launchUrl('https://g.co/kgs/5X8Q5xj');
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

