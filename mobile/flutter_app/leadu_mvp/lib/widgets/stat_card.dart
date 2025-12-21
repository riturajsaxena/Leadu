import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Today Sent\n12 / 50"),
            Text("Starter Plan", style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
