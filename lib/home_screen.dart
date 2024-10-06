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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70), // Adjust the height as needed
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Removes the back arrow
          flexibleSpace: Container(
            width: double.infinity, // Full width
            padding: EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
            color: Colors.grey.shade200, // Light gray background
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Keep items on the same line
              crossAxisAlignment: CrossAxisAlignment.center, // Vertically align to center
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,', style: TextStyle(fontSize: 16, color: Colors.black54)),
                    Text('Linda Myers', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage('https://example.com/profile_picture.png'), // Replace with a valid image or fallback to guest icon
                  onBackgroundImageError: (_, __) {
                    setState(() {});
                  },
                  child: Icon(Icons.person, color: Colors.grey), // Guest icon if no image
                ),
              ],
            ),
          ),
        ),
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildNavBarItem(Icons.home, "Home", _selectedIndex == 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarItem(Icons.contacts, "Contacts", _selectedIndex == 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarItem(Icons.medical_services, "Medical", _selectedIndex == 2),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarItem(Icons.settings, "Settings", _selectedIndex == 3),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent, // Keep background transparent
      ),
    );
  }

  // Function to create the icon with text next to it and a red square background
  Widget _buildNavBarItem(IconData icon, String label, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.red : Colors.transparent, // Red when selected, transparent when not
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding to make the box larger
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.grey), // White icon when selected
          if (isSelected) // Show label only when the item is selected
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                label,
                style: TextStyle(color: Colors.white), // White text
              ),
            ),
        ],
      ),
    );
  }
}
