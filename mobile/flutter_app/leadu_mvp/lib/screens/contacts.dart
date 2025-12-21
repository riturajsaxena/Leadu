import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  void loadContacts() async {
    contacts = await ApiService.getContacts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      body: contacts.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No contacts yet'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final res = await Navigator.push<bool?>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddContactPage(),
                        ),
                      );
                      if (res == true) loadContacts();
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Contact'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (_, i) {
                final c = contacts[i];
                return ListTile(
                  title: Text(c["name"]),
                  subtitle: Text(c["phone"]),
                  trailing: const Icon(Icons.chat),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Open Add Contact screen and refresh on success
          final res = await Navigator.push<bool?>(
            context,
            MaterialPageRoute(builder: (_) => const AddContactPage()),
          );
          if (res == true) loadContacts();
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
