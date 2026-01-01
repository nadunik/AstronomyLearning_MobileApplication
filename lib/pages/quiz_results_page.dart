import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizResultsPage extends StatelessWidget {
  const QuizResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A148C), // Deep purple background
      appBar: AppBar(
        title: const Text('Your Quiz Results'),
        backgroundColor: const Color(0xFF6A1B9A), // Slightly lighter purple
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quiz_results')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final results = snapshot.data!.docs;

          if (results.isEmpty) {
            return const Center(
              child: Text(
                "No quiz attempts yet.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final data = results[index].data() as Map<String, dynamic>;
              final date = DateFormat('yyyy-MM-dd – HH:mm')
                  .format(data['timestamp'].toDate());

              final score = "${data['correct']}/${data['total']}";
              final quizNumber = "Quiz #${results.length - index}";

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B1FA2), // Card purple
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(Icons.assignment_turned_in, color: Colors.white),
                  title: Text(
                    quizNumber,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Score: $score  •  $date",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
