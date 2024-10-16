import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final User? user; // Accept nullable User

  MedicalHistoryScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedBloodType = 'A+'; // Default value for dropdown
  final _chronicDiseasesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _loadMedicalHistory(); // Load medical history if user is not null
    }
  }

  Future<void> _loadMedicalHistory() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('UserInformation')
          .doc(widget.user!.uid) // Access user UID safely
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _heightController.text = data['Height'] ?? '';
          _weightController.text = data['Weight'] ?? '';
          _ageController.text = data['Age'] ?? '';
          _selectedBloodType = data['Blood Type'] ?? 'A+'; // Handle empty blood type
          _chronicDiseasesController.text = data['Chronic Diseases'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading medical history: $e')),
      );
    }
  }

  Future<void> _saveMedicalHistory() async {
    if (_formKey.currentState?.validate() == true) {
      try {
        await FirebaseFirestore.instance.collection('UserInformation').doc(widget.user!.uid).set({
          'Height': _heightController.text,
          'Weight': _weightController.text,
          'Blood Type': _selectedBloodType,
          'Age': _ageController.text,
          'Chronic Diseases': _chronicDiseasesController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Medical history saved successfully.'),
        ));

        // Navigate back to the home screen after saving medical history
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving medical history: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    if (widget.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Medical History'),
        ),
        body: Center(
          child: Text(
            'Please log in to access your medical history.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Medical History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Height
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? 'Please enter your height' : null,
              ),
              SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? 'Please enter your weight' : null,
              ),
              SizedBox(height: 16),

              // Age
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? 'Please enter your age' : null,
              ),
              SizedBox(height: 16),

              // Blood Type
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                decoration: InputDecoration(labelText: 'Blood Type'),
                items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map((value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBloodType = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Chronic Diseases
              TextFormField(
                controller: _chronicDiseasesController,
                decoration: InputDecoration(labelText: 'Chronic Diseases'),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveMedicalHistory,
                child: Text('Save Medical History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
