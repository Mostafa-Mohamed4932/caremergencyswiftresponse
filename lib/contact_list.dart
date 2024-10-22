import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> contacts = [];
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _requestContactPermission();
  }

  // Request contact permission
  Future<void> _requestContactPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      _fetchContacts();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Ask for permission if not granted
      if (await Permission.contacts.request().isGranted) {
        _fetchContacts();
      } else {
        // Handle if the permission is denied permanently
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contact permission denied'),
          ),
        );
        setState(() {
          isLoading = false; // Update loading state
        });
      }
    }
  }

  // Fetch contacts from the user's phone
  Future<void> _fetchContacts() async {
    try {
      Iterable<Contact> contactsFromPhone = await ContactsService.getContacts();
      setState(() {
        contacts = contactsFromPhone.toList();
        isLoading = false; // Update loading state
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Update loading state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching contacts: $e'),
        ),
      );
    }
  }

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch dialer'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : contacts.isEmpty
          ? Center(child: Text('No contacts found')) // Handle empty contacts
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];
          return ListTile(
            leading: (contact.avatar != null && contact.avatar!.isNotEmpty)
                ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar!))
                : CircleAvatar(child: Text(contact.initials())),
            title: Text(contact.displayName ?? 'No Name'),
            subtitle: contact.phones!.isNotEmpty
                ? Text(contact.phones!.first.value ?? '')
                : Text('No Phone Number'),
            onTap: () {
              // If the contact has a phone number, initiate a call
              if (contact.phones!.isNotEmpty) {
                String phoneNumber = contact.phones!.first.value!;
                _makePhoneCall(phoneNumber);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No phone number available'),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
