
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  void toggleFormMode() => setState(() => isLogin = !isLogin);

  Future<void> authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    if (isLogin) {
      final user = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        _showSnackbar('Login successful');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSnackbar('Login failed. Check credentials.');
      }
    } else {
      final user = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        //fullName: _fullNameController.text.trim(),
      );
      if (user != null) {
        _showSnackbar('Account created');
        Navigator.pushReplacementNamed(context, '/profileSetup');
      } else {
        _showSnackbar('Signup failed. Try again.');
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      _showSnackbar('Google sign-in successful');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnackbar('Google sign-in failed.');
    }
  }

  Future<void> resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showSnackbar("Enter your email to reset password.");
      return;
    }

    await _authService.resetPassword(_emailController.text.trim());
    _showSnackbar("Password reset email sent.");
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/black.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? 'Login' : 'Sign Up',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!isLogin)
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white70,
                          ),
                          validator: (value) =>
                              value != null && value.isNotEmpty ? null : 'Enter your full name',
                        ),
                      if (!isLogin) const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white70,
                        ),
                        validator: (value) =>
                            value != null && value.contains('@') ? null : 'Enter a valid email',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white70,
                        ),
                        validator: (value) =>
                            value != null && value.length >= 6 ? null : 'Min 6 characters required',
                      ),
                      if (isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading ? null : resetPassword,
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: isLoading ? null : authenticate,
                        child: Text(isLogin ? 'Login' : 'Sign Up'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: isLoading ? null : signInWithGoogle,
                        icon: const Icon(Icons.login),
                        label: const Text('Sign in with Google'),
                      ),
                      TextButton(
                        onPressed: toggleFormMode,
                        child: Text(
                          isLogin
                              ? 'Don\'t have an account? Sign up'
                              : 'Already have an account? Login',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
