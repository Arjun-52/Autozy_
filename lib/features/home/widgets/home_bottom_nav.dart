import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.orange,
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
