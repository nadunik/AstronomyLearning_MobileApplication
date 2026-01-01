import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class ProfileSetupPage extends StatefulWidget {
  final String fullName;
  final String email;

  const ProfileSetupPage({
    super.key,
    required this.fullName,
    required this.email,
  });

  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  String? _selectedGender;
  File? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  /*Future<void> _submitProfile() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String? imageUrl;
    if (_profileImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');
      await storageRef.putFile(_profileImage!);
      imageUrl = await storageRef.getDownloadURL();
    }

    // Save user profile to Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'full_name': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'age': _ageController.text.trim(),
      'gender': _selectedGender,
      'profile_pic_url': imageUrl ?? '',
      'created_at': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile setup successful')),
    );

    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}*/

  Future<void> _submitProfile() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String? imageBase64;
    if (_profileImage != null) {
      final bytes = await _profileImage!.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }

    // Save user profile to Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'full_name': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'age': _ageController.text.trim(),
      'gender': _selectedGender,
      'profile_pic_base64': imageBase64 ?? '',
      'created_at': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile setup successful')),
    );

    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.purple;
    const accentColor = Colors.white;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/planet.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Form content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Profile Setup',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      style: const TextStyle(color: primaryColor),
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: primaryColor),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: accentColor,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: primaryColor),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: primaryColor),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: accentColor,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Age
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: primaryColor),
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        labelStyle: TextStyle(color: primaryColor),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: accentColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Gender
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      dropdownColor: accentColor,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(color: primaryColor),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: accentColor,
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: const TextStyle(color: primaryColor),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) return 'Select a gender';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Profile Image
                    _profileImage == null
                        ? ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: accentColor,
                            ),
                            child: const Text('Pick Profile Picture'),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_profileImage!, height: 150),
                          ),
                    const SizedBox(height: 20),

                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _submitProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: accentColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
