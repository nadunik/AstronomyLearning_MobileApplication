import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/gestures.dart';
import 'package:astronomy_application/services/progress_service.dart';
import 'package:flutter/services.dart';
import 'package:astronomy_application/pages/planets/mercury.dart';
import 'package:astronomy_application/pages/planets/venus.dart';
import 'package:astronomy_application/pages/planets/earth.dart';
import 'package:astronomy_application/pages/planets/mars.dart';
import 'package:astronomy_application/pages/planets/jupiter.dart';
import 'package:astronomy_application/pages/planets/saturn.dart';
import 'package:astronomy_application/pages/planets/uranus.dart';
import 'package:astronomy_application/pages/planets/neptune.dart';
//import 'package:astronomy_application/pages/unity_solar.dart';


class SolarSystemPage extends StatefulWidget {
  const SolarSystemPage({Key? key}) : super(key: key);

  @override
  _SolarSystemPageState createState() => _SolarSystemPageState();
}

class _SolarSystemPageState extends State<SolarSystemPage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  //static const platform = MethodChannel('com.example.unity/channel');

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('images/solarr.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /*Future<void> _launchUnityScene() async {
    try {
      await platform.invokeMethod('launchUnity');
    } on PlatformException catch (e) {
      print("Failed to launch Unity scene: '${e.message}'.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to launch 3D scene: ${e.message}')),
      );
    }
  }*/

  Widget _buildVideoPlayer() {
    if (_isVideoInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    } else {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  TextSpan _planetLink(BuildContext context, String name, Widget page) {
    return TextSpan(
      text: name,
      style: const TextStyle(
        color: Colors.lightBlueAccent,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
    );
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
                      'images/solar_banner.jpg',
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
                        'Solar System',
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
                          '''Our solar system is located in the Milky Way, a barred spiral galaxy with two major arms, and two minor arms. Our Sun is in a small, partial arm of the Milky Way called the Orion Arm, or Orion Spur, between the Sagittarius and Perseus arms. Our solar system orbits the center of the galaxy at about 515,000 mph (828,000 kph). It takes about 230 million years to complete one orbit around the galactic center.

Our solar system extends much farther than the planets that orbit the Sun. The solar system also includes the Kuiper Belt that lies past Neptune's orbit. This is a ring of icy bodies, almost all smaller than the most popular Kuiper Belt Object – dwarf planet Pluto.

Beyond the fringes of the Kuiper Belt is the Oort Cloud. This giant spherical shell surrounds our solar system. It has never been directly observed, but its existence is predicted based on mathematical models and observations of comets that likely originate there.

The Oort Cloud is made of icy pieces of space debris - some bigger than mountains – orbiting our Sun as far as 1.6 light-years away. This shell of material is thick, extending from 5,000 astronomical units to 100,000 astronomical units. One astronomical unit (or AU) is the distance from the Sun to Earth, or about 93 million miles (150 million kilometers).

The Oort Cloud is the boundary of the Sun's gravitational influence, where orbiting objects can turn around and return closer to our Sun.''',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'images/planets.jpeg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'A Graphical Representation of Planets in Our Solar System',
                            style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                            children: [
                              const TextSpan(
                                text:
                                    '''The Sun's heliosphere doesn't extend quite as far. The heliosphere is the bubble created by the solar wind – a stream of electrically charged gas blowing outward from the Sun in all directions. The boundary where the solar wind is abruptly slowed by pressure from interstellar gases is called the termination shock. This edge occurs between 80-100 astronomical units.

Our solar system formed about 4.6 billion years ago from a dense cloud of interstellar gas and dust. The cloud collapsed, possibly due to the shockwave of a nearby exploding star, called a supernova. When this dust cloud collapsed, it formed a solar nebula – a spinning, swirling disk of material.

At the center, gravity pulled more and more material in. Eventually, the pressure in the core was so great that hydrogen atoms began to combine and form helium, releasing a tremendous amount of energy. With that, our Sun was born, and it eventually amassed more than 99% of the available matter.

Matter farther out in the disk was also clumping together. These clumps smashed into one another, forming larger and larger objects. Some of them grew big enough for their gravity to shape them into spheres, becoming planets, dwarf planets, and large moons. In other cases, planets did not form: the asteroid belt is made of bits and pieces of the early solar system that could never quite come together into a planet. Other smaller leftover pieces became asteroids, comets, meteoroids, and small, irregular moons.\n\n- ''',
                              ),
                              _planetLink(context, 'Mercury', const MercuryPage()),
                              const TextSpan(text: ': The closest planet to the Sun.\n- '),
                              _planetLink(context, 'Venus', const VenusPage()),
                              const TextSpan(text: ': Known as Earth’s twin because of its similar size.\n- '),
                              _planetLink(context, 'Earth', const EarthPage()),
                              const TextSpan(text: ': Our home planet.\n- '),
                              _planetLink(context, 'Mars', const MarsPage()),
                              const TextSpan(text: ': The red planet, known for its iron oxide surface.\n- '),
                              _planetLink(context, 'Jupiter', const JupiterPage()),
                              const TextSpan(text: ': The largest planet in our Solar System.\n- '),
                              _planetLink(context, 'Saturn', const SaturnPage()),
                              const TextSpan(text: ': Famous for its stunning ring system.\n- '),
                              _planetLink(context, 'Uranus', const UranusPage()),
                              const TextSpan(text: ': An ice giant with a unique sideways rotation.\n- '),
                              _planetLink(context, 'Neptune', const NeptunePage()),
                              const TextSpan(text: ': The farthest known planet from the Sun.\n\nThe Sun is a star at the center of the Solar System, providing the heat and light necessary for life on Earth.\n\nExploring the Solar System helps us understand more about our origins and the possibility of life elsewhere.'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Visual Tour of Solar System',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildVideoPlayer(),
                      const SizedBox(height: 30),

                      /*Center(
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UnitySolarSystemPage()),
      );
    },
    icon: const Icon(Icons.threed_rotation),
    label: const Text("View 3D Solar System"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
),*/
const SizedBox(height: 20),

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
                        
                        ElevatedButton.icon(
                          onPressed: () async {
                            await updateProgress("Solar System", 20);
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
                        ),],),
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

