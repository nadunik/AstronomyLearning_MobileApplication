import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:astronomy_application/pages/home.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:astronomy_application/pages/onboarding.dart';
import 'package:astronomy_application/pages/login_page.dart';
import 'package:astronomy_application/pages/signup_page.dart';
import 'package:astronomy_application/pages/profile_page.dart';
import 'package:astronomy_application/pages/profile_setup_page.dart';
import 'package:astronomy_application/pages/solar_system.dart';
import 'package:astronomy_application/pages/galaxies.dart';
import 'package:astronomy_application/pages/star_map_page.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:astronomy_application/pages/ar_page.dart';
import 'package:astronomy_application/pages/learning_progress.dart';
import 'package:astronomy_application/pages/edit_profile.dart';
import 'package:astronomy_application/pages/StarScannerDemo.dart';
import 'package:astronomy_application/pages/quiz_topic_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //FirebaseFirestore.instance.collection('test').add({'message': 'Hello Firebase'});

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/onboarding',
      //initialRoute: '/home',
      routes: {
        '/onboarding': (context) => const Onboarding(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const Home(),
        '/profile': (context) => const ProfilePage(),
        '/profileSetup': (context) => const ProfileSetupPage(fullName:'',email: '',),// fix the name and email so it would pass the user name and email
        '/solarSystem': (context) => const SolarSystemPage(),
        '/galaxies': (context) => const GalaxiesPage(),
        '/star-map': (context) => StarMapPage(),
        //'/stellarium': (context) => StellariumFullScreenPage(),
        '/ar-page': (context) => StarPatternARPage(),
        '/learningProgress': (context) => const LearningProgressPage(),
        //'/edit-profile': (context) => const EditProfilePage(),
        '/edit-profile': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return EditProfilePage(userData: args);
  },
        '/starScanner': (context) => StarScannerDemoPage(),
        '/quiz' : (context) => QuizTopicPage(),

    
      },
    );
  }
}
