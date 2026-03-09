import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,

      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,

      selectedIconTheme: const IconThemeData(color: Colors.grey),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),

      selectedLabelStyle: const TextStyle(color: Colors.grey),
      unselectedLabelStyle: const TextStyle(color: Colors.grey),

      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      enableFeedback: false,

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
