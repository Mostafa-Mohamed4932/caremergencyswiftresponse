import 'package:flutter/material.dart';

class DoubleParkingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Double Parking'),
      ),
      body: Center(
        child: Text(
          'This is the Double Parking Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
