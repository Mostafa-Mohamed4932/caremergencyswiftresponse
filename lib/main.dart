import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Firestore Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserInformationScreen(),
    );
  }
}

class UserInformationScreen extends StatelessWidget {
  final CollectionReference users = FirebaseFirestore.instance.collection('UserInformation');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final userDocuments = snapshot.data?.docs;

          if (userDocuments == null || userDocuments.isEmpty) {
            return Center(child: Text('No User Information found.'));
          }

          return ListView(
            children: userDocuments.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(
                  'Name: ${data['Name']}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Id: ${data['Id']}',
                  style: TextStyle(fontSize: 50.0,fontWeight:FontWeight.bold),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
