import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final User user;

  MedicalHistoryScreen({required this.user});

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
    _loadMedicalHistory();
  }

  Future<void> _loadMedicalHistory() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('UserInformation')
        .doc(widget.user.uid)
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
  }

  Future<void> _saveMedicalHistory() async {
    if (_formKey.currentState?.validate() == true) {
      await FirebaseFirestore.instance.collection('UserInformation').doc(widget.user.uid).set({
        'Height': _heightController.text,
        'Weight': _weightController.text,
        'Blood Type': _selectedBloodType,
        'Age': _ageController.text,
        'Chronic Diseases': _chronicDiseasesController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Medical history saved successfully.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Height - number only
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number, // Allow only numbers
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Weight - number only
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number, // Allow only numbers
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Age - number only
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number, // Allow only numbers
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Blood Type - dropdown menu
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                decoration: InputDecoration(labelText: 'Blood Type'),
                items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBloodType = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Chronic Diseases - unchanged
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
