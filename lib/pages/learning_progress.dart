import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LearningProgressPage extends StatelessWidget {
  const LearningProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Progress'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  
          },
        ),
      ),
      body: user == null
          ? const Center(child: Text('No user found'))
          : Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'images/333.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),

                // Main content
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final progress = data['progress'] ?? {};

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: progress.entries.map<Widget>((entry) {
                        return Card(
                          color: Colors.deepPurpleAccent.withOpacity(0.8),
                          child: ListTile(
                            title: Text(
                              entry.key,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: LinearProgressIndicator(
                              value: (entry.value as int) / 100.0,
                              backgroundColor: Colors.white24,
                              color: Colors.greenAccent,
                            ),
                            trailing: Text(
                              '${entry.value}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
