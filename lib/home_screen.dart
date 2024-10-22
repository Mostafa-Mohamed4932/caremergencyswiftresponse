import 'package:flutter/material.dart';
import 'contact_list.dart'; // Import your Contact List screen
import 'medical_history.dart'; // Import your Medical History screen
import 'Alert.dart'; // Import your Alert screen
import 'settings.dart'; // Import your Settings page
import 'package:firebase_auth/firebase_auth.dart';
import 'request.dart'; // Import your Request Screen
import 'double_parking.dart'; // Import your Double Parking screen

class EmergencyHomeScreen extends StatefulWidget {
  final User? user; // Make the user parameter nullable

  EmergencyHomeScreen({Key? key, this.user}) : super(key: key); // Pass user as nullable

  @override
  _EmergencyHomeScreenState createState() => _EmergencyHomeScreenState();
}

class _EmergencyHomeScreenState extends State<EmergencyHomeScreen> {
  int _selectedIndex = 0;

  // List of screens corresponding to each tab
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(), // The main emergency screen
      ContactListPage(), // Contact list screen
      MedicalHistoryScreen(user: widget.user), // Pass user to Medical History
      AlertScreen(), // Alert screen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Switch between the screens
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency App'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings), // Settings icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()), // Navigate to the Settings page
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex], // Display the selected screen based on the bottom nav item tapped
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// The Home Screen with the big red emergency button and an additional button for double parking
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
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
                        // Navigate to RequestScreen when the button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RequestScreen()),
                        );
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
                                  Colors.red.shade800,
                                  Colors.red.shade500,
                                ],
                                stops: [0.6, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.6),
                                  spreadRadius: 5,
                                  blurRadius: 15,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.touch_app, size: 50, color: Colors.white),
                        ],
                      ),
                    ),
                    SizedBox(height: 20), // Space between buttons
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to DoubleParkingScreen when the button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DoubleParkingScreen()),
                        );
                      },
                      icon: Icon(Icons.local_parking), // Icon for the button
                      label: Text('Report Double Parking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button background color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom Bottom Navigation Bar component
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        _buildNavBarItem(Icons.home, "Home", selectedIndex == 0),
        _buildNavBarItem(Icons.contacts, "Contacts", selectedIndex == 1),
        _buildNavBarItem(Icons.medical_services, "Medical History", selectedIndex == 2),
        _buildNavBarItem(Icons.warning, "Alerts", selectedIndex == 3),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.transparent,
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.grey),
                if (isSelected)
                  Text(
                    label,
                    style: TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
      label: '',
    );
  }
}
