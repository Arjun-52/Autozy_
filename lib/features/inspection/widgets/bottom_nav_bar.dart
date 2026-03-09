import 'package:autozy/features/vehicles/vehicles_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,

      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VehicleScreen()),
          );
        }
      },

      selectedItemColor: const Color(0xffC68A00),
      unselectedItemColor: Colors.grey,

      showUnselectedLabels: true,
      showSelectedLabels: true,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car_outlined),
          label: "Vehicles",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Plans"),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}
