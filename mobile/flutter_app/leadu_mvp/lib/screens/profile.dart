import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 32,
              child: Icon(Icons.person, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              "user@leadu.com",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Plan: Starter"),
            const SizedBox(height: 8),
            const Text("Daily Limit: 50 messages"),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text("Support"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
