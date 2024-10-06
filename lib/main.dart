import 'package:flutter/material.dart';
import 'login.dart'; // Import the login screen
import 'home_screen.dart'; // Import the home screen for future navigation

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: LoginScreen(), // Navigate to Login Screen first
      routes: {
        '/home': (context) => EmergencyHomeScreen(), // Route to EmergencyHomeScreen
      },
    );
  }
}

// Bottom Navigation Bar widget to be accessible from other screens
class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildNavBarItem(Icons.home, "Home", widget.selectedIndex == 0),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildNavBarItem(Icons.contacts, "Contacts", widget.selectedIndex == 1),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildNavBarItem(Icons.medical_services, "Medical", widget.selectedIndex == 2),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildNavBarItem(Icons.settings, "Settings", widget.selectedIndex == 3),
          label: '',
        ),
      ],
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.red : Colors.transparent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.grey),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                label,
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
