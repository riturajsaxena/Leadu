import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.campaign, size: 80, color: Color(0xFF1F8A70)),
            SizedBox(height: 12),
            Text(
              "Leadu",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text("Convert Leads into Conversations"),
          ],
        ),
      ),
    );
  }
}
