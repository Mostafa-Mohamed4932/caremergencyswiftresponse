import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import your Emergency Home Screen
import 'contact_list.dart'; // Import your Contact List Screen
import 'medical_history.dart'; // Import your Medical History Screen
import 'about.dart'; // Import your Settings Screen

void main() {
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
      home: EmergencyHomeScreen(), // Start with the Emergency Home Screen
      routes: {
        '/contacts': (context) => ContactListScreen(), // Route to the Contact List
        '/medical': (context) => MedicalHistoryScreen(), // Route to Medical History
        '/about': (context) => AboutScreen(), // Route to Settings
      },
    );
  }
}