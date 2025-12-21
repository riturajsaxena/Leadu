import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../services/api_service.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _importFromDevice() async {
    final granted = await FlutterContacts.requestPermission();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacts permission denied')),
      );
      return;
    }

    final contacts = await FlutterContacts.getContacts(withProperties: true);
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No contacts found')));
      return;
    }

    final choice = await showDialog<Contact?>(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Text('Select contact to import'),
        children: contacts.take(50).map((ct) {
          final name = ct.displayName;
          final phone = ct.phones.isNotEmpty ? ct.phones.first.number : '';
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(c, ct),
            child: ListTile(title: Text(name), subtitle: Text(phone)),
          );
        }).toList(),
      ),
    );

    if (choice != null) {
      setState(() {
        _nameCtrl.text = choice.displayName;
        _phoneCtrl.text = choice.phones.isNotEmpty
            ? choice.phones.first.number
            : '';
      });
    }
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and phone')),
      );
      return;
    }
    setState(() => _loading = true);
    final ok = await ApiService.addContact(name, phone);
    setState(() => _loading = false);
    if (ok)
      Navigator.pop(context, true);
    else
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save contact')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _importFromDevice,
              icon: const Icon(Icons.upload_file),
              label: const Text('Import from device contacts'),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


