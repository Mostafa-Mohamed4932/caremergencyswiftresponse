import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login.dart'; // Import your Login Page
import 'contact_list.dart'; // Import your Contact List Screen
import 'medical_history.dart'; // Import your Medical History Screen
import 'about.dart'; // Import your About Screen
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widget binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Start with the LoginPage
      routes: {
        '/contacts': (context) => ContactListPage(), // Route to the Contact List
        '/medical': (context) => MedicalHistoryScreen(user: FirebaseAuth.instance.currentUser!), // Route to Medical History
        '/about': (context) => AboutScreen(), // Route to About
        '/home': (context) => EmergencyHomeScreen(user: FirebaseAuth.instance.currentUser), // Route to Home Screen
      },
    );
  }
}
