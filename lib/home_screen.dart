import 'package:flutter/material.dart';
import 'main.dart'; // Import the bottom nav bar

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
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,', style: TextStyle(fontSize: 16, color: Colors.black54)),
                      Text('Linda Myers', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage('https://example.com/profile_picture.png'),
                  onBackgroundImageError: (_, __) {
                    setState(() {});
                  },
                  child: Icon(Icons.person, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
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
                        onTapDown: (_) {
                          _controller.reverse();
                        },
                        onTapUp: (_) {
                          _controller.forward();
                          print('Emergency button pressed');
                        },
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
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
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// In your CustomBottomNavBar (from main.dart):
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
        _buildNavBarItem(Icons.medical_services, "Medical", selectedIndex == 2),
        _buildNavBarItem(Icons.settings, "Settings", selectedIndex == 3),
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
            width: 50, // Adjusted width for the red square box
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
          ),
          Text(
            label,
            style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
          ),
        ],
      ),
      label: '',
    );
  }
}
