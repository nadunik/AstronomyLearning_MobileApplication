import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:astronomy_application/pages/quiz_results_page.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No user logged in');
    return await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  }

  Future<Map<String, dynamic>> _getUserProgress() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('No user logged in');
  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return Map<String, dynamic>.from(doc.data()?['progress'] ?? {});
  }


  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _editProfile(BuildContext context, Map<String, dynamic> data) {
    Navigator.pushNamed(
      context,
      '/edit-profile',
      arguments: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.purple;
    const accentColor = Colors.white;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/astronut2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // User Info
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: _getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No profile data found', style: TextStyle(color: Colors.white)));
              }

              final data = snapshot.data!.data()!;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*// Profile Picture
                      if (data['profile_pic_url'] != null && data['profile_pic_url'] != '')
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(data['profile_pic_url']),
                        )
                      else
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: primaryColor,
                          child: Icon(Icons.person, size: 60, color: accentColor),
                        ),
                      const SizedBox(height: 20),*/

                      // Profile Picture
if (data['profile_pic_base64'] != null && data['profile_pic_base64'] != '')
  CircleAvatar(
    radius: 60,
    backgroundImage: MemoryImage(base64Decode(data['profile_pic_base64'])),
  )
else
  const CircleAvatar(
    radius: 60,
    backgroundColor: primaryColor,
    child: Icon(Icons.person, size: 60, color: accentColor),
  ),


                      // Full Name
                      Text(
                        data['full_name'] ?? '',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      // Email
                      Text(
                        data['email'] ?? '',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      // Age and Gender
                      InfoTile(label: 'Age', value: data['age'] ?? ''),
                      InfoTile(label: 'Gender', value: data['gender'] ?? ''),

                      // Joined date
                      if (data['created_at'] != null)
                        InfoTile(
                          label: 'Joined',
                          value: (data['created_at'] as Timestamp).toDate().toLocal().toString().split(' ')[0],
                        ),
                      const SizedBox(height: 24),

                      // Progress Summary Section
                      FutureBuilder<Map<String, dynamic>>(
                        future: _getUserProgress(), // define this below
                        builder: (context, progressSnapshot) {
                          if (progressSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(color: Colors.white);
                          }

                          if (!progressSnapshot.hasData || progressSnapshot.data!.isEmpty) {
                            return const Text('No progress tracked yet.', style: TextStyle(color: Colors.white));
                          }

                          final progress = progressSnapshot.data!;
                          final totalTopics = progress.length;
                          final completedTopics = progress.values.where((v) => v == 100).length;
                          final percent = (completedTopics / totalTopics) * 100;

                          return Column(
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                'Learning Progress',
                                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: percent / 100,
                                backgroundColor: Colors.white24,
                                color: Colors.purpleAccent,
                                minHeight: 10,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${percent.toStringAsFixed(1)}% completed',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/learningProgress'),
                                icon: const Icon(Icons.assessment),
                                label: const Text('View Detailed Progress'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      ElevatedButton(
  child: Text("View Quiz Results"),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizResultsPage()),
    );
  },
),


                      // Edit Profile Button
                      ElevatedButton.icon(
                        onPressed: () => _editProfile(context, data),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Logout Button
                      ElevatedButton.icon(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.purple;
    const accentColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(color: primaryColor)),
          ],
        ),
      ),
    );
  }
}
