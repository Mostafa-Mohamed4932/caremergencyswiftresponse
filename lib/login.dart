import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart'; // Ensure you import home_screen.dart
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final CollectionReference users = FirebaseFirestore.instance.collection('UserInformation');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Password Input
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              // Login Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _loginUser();
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white), // Set the text color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red background color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to log in the user
  Future<void> _loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Check if the user exists in Firestore with the provided email and password
      QuerySnapshot querySnapshot = await users
          .where('Email', isEqualTo: email)
          .where('Password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User exists, navigate to the home page
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Successful!'),
        ));

        // Navigate to the home screen (home_screen.dart)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserInformationScreen()), // Ensure HomeScreen is imported
        );
      } else {
        // Invalid email or password
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid email or password. Please try again.'),
        ));
      }
    } catch (e) {
      print('Error logging in: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to log in. Please try again.'),
      ));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}