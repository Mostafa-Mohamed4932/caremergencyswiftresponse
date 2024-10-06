import 'package:flutter/material.dart';

class EmergencyHomeScreen extends StatefulWidget {
  @override
  _EmergencyHomeScreenState createState() => _EmergencyHomeScreenState();
}

class _EmergencyHomeScreenState extends State<EmergencyHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add functionality for each tab here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back,', style: TextStyle(fontSize: 16, color: Colors.black54)),
              Text('Linda Myers', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/profile_picture.png'), // Replace with a valid image or fallback to guest icon
            onBackgroundImageError: (_, __) {
              setState(() {});
            },
            child: Icon(Icons.person, color: Colors.grey), // Guest icon
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Having an Emergency?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Press the button below, help will arrive soon.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                // Add emergency button functionality here
                print('Emergency button pressed');
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.red.shade900, // Darker red color
                          Colors.red.shade700, // Slightly lighter red for gradient effect
                        ],
                        stops: [0.5, 1.0], // Adjust for a smooth gradient effect
                      ),
                    ),
                  ),
                  Icon(Icons.touch_app, size: 50, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey), // Gray icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts, color: Colors.grey), // Gray icon
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services, color: Colors.grey), // Gray icon
            label: 'Medical History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.grey), // Gray icon
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red, // Red when selected
        unselectedItemColor: Colors.grey, // Gray when unselected
        onTap: _onItemTapped,
      ),
    );
  }
}
