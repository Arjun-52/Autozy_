import 'package:flutter/material.dart';
import '../../../../core/services/navigation_service.dart';

class InspectionHomeButton extends StatelessWidget {
  const InspectionHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,

      child: ElevatedButton(
        onPressed: () {
          NavigationService.navigateAndClearStackPathWithArgs(
            context,
            '/home',
            arguments: true,
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
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
