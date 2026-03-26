import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,

      onTap: (index) {
        if (index == 1) {
          context.go('/home/vehicles');
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
