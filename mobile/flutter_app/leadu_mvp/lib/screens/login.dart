import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/primary_button.dart';
import 'dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Leadu Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: "Login",
              onPressed: () async {
                final success = await ApiService.login(
                  emailController.text,
                  passwordController.text,
                );

                if (success && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
