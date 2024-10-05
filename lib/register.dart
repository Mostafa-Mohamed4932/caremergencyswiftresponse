import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; // Import the login page

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers for input fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Firestore instance
  final CollectionReference users = FirebaseFirestore.instance.collection('UserInformation');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0, // Removes shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Let\'s help you set up your account, it won\'t take long.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),

              // Name Input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded edges
                    borderSide: BorderSide(color: Colors.grey), // Border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey), // Color when enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue), // Color when focused
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Email validation logic
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
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Confirm Password Input
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Sign Up Button (red with white text)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _registerUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white, // Text color is white
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to register user, check for existing IDs, generate new ID, and save to Firestore
  Future<void> _registerUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Query existing IDs
      QuerySnapshot snapshot = await users.orderBy('ID', descending: true).limit(1).get();

      int nextId = 1; // Default ID in case the collection is empty
      if (snapshot.docs.isNotEmpty) {
        // Get the highest existing ID
        var highestID = snapshot.docs.first['ID'];
        nextId = highestID + 1;
      }

      // Save user data to Firestore with the new unique ID
      await users.add({
        'ID': nextId,
        'Name': name,
        'Email': email,
        'Password': password,  // Note: Storing plain-text password is not recommended. Use proper authentication and hashing.
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User Registered Successfully! Your ID: $nextId'),
      ));

      // Clear form fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // Navigate to the login page after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),  // Navigate to "login.dart"
      );

    } catch (e) {
      print('Error adding user: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register user. Please try again.'),
      ));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
