import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  // Request permission and get contacts
  Future<void> _getContacts() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts.toList();
      });
    } else {
      // If permission is denied, you can show a message to the user.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission denied to access contacts'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: _contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts[index];
          return ListTile(
            leading: (contact.avatar != null && contact.avatar!.isNotEmpty)
                ? CircleAvatar(
              backgroundImage: MemoryImage(contact.avatar!),
            )
                : CircleAvatar(
              child: Text(contact.initials()),
            ),
            title: Text(contact.displayName ?? ''),
            subtitle: Text(
              contact.phones!.isNotEmpty
                  ? contact.phones!.first.value ?? ''
                  : 'No phone number',
            ),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              // Add functionality for when a contact is tapped
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new contact functionality
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red, // Set the color of the button to red
      ),
    );
  }
}
