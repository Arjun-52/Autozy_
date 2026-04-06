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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 4),

        Text(
          "Here’s your daily update",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xff7E848D),
          ),
        ),
      ],
    );
  }
}
