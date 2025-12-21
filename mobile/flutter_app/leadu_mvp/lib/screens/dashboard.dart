import 'package:flutter/material.dart';
import 'home.dart';
import 'contacts.dart';
import 'campaigns.dart';
import 'profile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ContactsScreen(),
    CampaignsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: const Color(0xFF1F8A70),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Contacts"),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: "Campaigns",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
