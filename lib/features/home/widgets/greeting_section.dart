import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Good morning!",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 4),

        Text("Here’s your daily update", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
