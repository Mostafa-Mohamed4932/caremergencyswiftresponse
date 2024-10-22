import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login.dart'; // Import your Login Page
import 'contact_list.dart'; // Import your Contact List Screen
import 'medical_history.dart'; // Import your Medical History Screen
import 'Alert.dart'; // Import your Alert Screen
import 'request.dart'; // Import your Request Screen
import 'settings.dart'; // Import your Settings Page
import 'package:firebase_auth/firebase_auth.dart';
import 'double_parking.dart';

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
        '/about': (context) => AlertScreen(), // Route to Alert
        '/home': (context) => EmergencyHomeScreen(user: FirebaseAuth.instance.currentUser), // Route to Home Screen
        '/request': (context) => RequestScreen(), // Route to Request Screen
        '/double_parking': (context) => DoubleParkingScreen(), // Route to Double Parking Screen
        '/settings': (context) => SettingScreen(), // Route to Settings Page
      },
    );
  }
}
