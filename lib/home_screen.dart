import 'package:flutter/material.dart';

class EmergencyHomeScreen extends StatefulWidget {
  @override
  _EmergencyHomeScreenState createState() => _EmergencyHomeScreenState();
}

class _EmergencyHomeScreenState extends State<EmergencyHomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Set up the animation controller and scale animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.0,
    )..addListener(() {
      setState(() {});
    });

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add functionality for each tab here
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              onTapDown: (_) {
                _controller.reverse(); // Shrink the button on press
              },
              onTapUp: (_) {
                _controller.forward(); // Return to normal size after press
                print('Emergency button pressed');
                // Add any emergency button functionality here
              },
              child: Transform.scale(
                scale: _scaleAnimation.value, // Use the animated scale value
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
                            Colors.red.shade800, // Slightly darker red
                            Colors.red.shade500, // Lighter red
                          ],
                          stops: [0.6, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.6),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: Offset(0, 10), // Shadow below the button
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.touch_app, size: 50, color: Colors.white),
                  ],
                ),
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
