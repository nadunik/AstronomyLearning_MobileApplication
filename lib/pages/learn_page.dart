import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 71, 18, 108),
              Color(0xFF1B003B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Section
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/sss copy.png'), 
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Let\'s Explore the Universe!',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Topics to Explore',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // List of subtopics
                _buildSubtopicCard('Solar System', context, '/solarSystem'),
                _buildSubtopicCard('Galaxies', context, '/galaxies'),
                _buildSubtopicCard('Astronuts', context, '/astronuts'),
                _buildSubtopicCard('Astronomy Theories', context, '/astronomyTheories'),
                _buildSubtopicCard('Space Missions', context, '/spaceMissions'),
                _buildSubtopicCard('Aliens', context, '/aliens'),
                _buildSubtopicCard('Black Holes', context, '/blackHoles'),
                _buildSubtopicCard('Nebula', context, '/nebula'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build subtopic cards
  Widget _buildSubtopicCard(String title, BuildContext context, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route); // Navigate to the respective page
      },
      child: Card(
        color: Colors.deepPurpleAccent,
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          trailing: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
