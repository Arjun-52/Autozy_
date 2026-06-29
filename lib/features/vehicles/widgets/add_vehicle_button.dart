import 'package:autozy/features/vehicles/screens/add_vehicle_screen.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF6E3), // light background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFF6C431), // yellow border
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Color(0xFFF6C431), size: 20),
            SizedBox(width: 6),
            Text(
              "Add Vehicle",
              style: TextStyle(
                color: Color(0xFFF6C431),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
