import 'package:autozy/features/vehicles/screens/add_vehicle_screen.dart';
import 'package:flutter/material.dart';

class AddVehicleButton extends StatelessWidget {
  const AddVehicleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const AddVehicleScreen();
          },
        );
      },

      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffC68A00), width: 2),
        ),
        child: const Center(
          child: Text(
            "+  Add Vehicle",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xffC68A00),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
