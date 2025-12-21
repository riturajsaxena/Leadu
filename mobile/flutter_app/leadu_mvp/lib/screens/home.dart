import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../api_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leadu Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const StatCard(),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Add Contact"),
              onTap: () async {
                final nameCtrl = TextEditingController();
                final phoneCtrl = TextEditingController();

                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Add Contact'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: phoneCtrl,
                          decoration: const InputDecoration(labelText: 'Phone'),
                        ),
                        const SizedBox(height: 12),
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
                                onPressed: () async {
                                  final name = nameCtrl.text.trim();
                                  final phone = phoneCtrl.text.trim();
                                  if (name.isEmpty || phone.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill name and phone',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  final ok = await ApiService.addContact(
                                    name,
                                    phone,
                                  );
                                  Navigator.pop(context, ok);
                                },
                                child: const Text('Save'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );

                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact saved')),
                  );
                } else if (result == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to save contact')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign),
              title: const Text("Create Campaign"),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Create Campaign not implemented'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text("Send WhatsApp"),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Send WhatsApp not implemented')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
