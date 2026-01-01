import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateProgress(String topic, int percentage) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('No user logged in');

  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await userDoc.set({
    'progress': {
      topic: percentage,
    }
  }, SetOptions(merge: true));
}
