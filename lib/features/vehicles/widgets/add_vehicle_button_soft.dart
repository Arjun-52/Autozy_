import 'package:flutter/material.dart';

class AddVehicleButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddVehicleButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF0).withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF6C431), width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Color(0xFFF6C431)),
            SizedBox(width: 8),
            Text(
              "Add Vehicle",
              style: TextStyle(
                color: Color(0xffDD900C),
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
