import 'package:autozy/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class InspectionHomeButton extends StatelessWidget {
  const InspectionHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,

      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(showPlanActiveCard: true),
            ),
          );
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF6C431),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        child: const Text(
          "Home",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
