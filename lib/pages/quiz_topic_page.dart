import 'package:flutter/material.dart';
import 'quiz_page.dart';

class QuizTopicPage extends StatelessWidget {
  final List<String> topics = ['Planets', 'Stars', 'Galaxies']; // Customize

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF6A1B9A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      extendBodyBehindAppBar: true, // To allow background image behind the app bar
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/milkywayy.jpg', 
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay 
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    purple.withOpacity(0.8),
                    purple.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Content with centered topics
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: topics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: purple,
                        minimumSize: Size(250, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        shadowColor: purple.withOpacity(0.5),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(),
                          ),
                        );
                      },
                      child: Text(
                        topic,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


