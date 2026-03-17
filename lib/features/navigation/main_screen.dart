import 'package:autozy/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/vehicles/screens/vehicles_screen.dart';
import '../../features/plans/screens/plans_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;

  final List<Widget> screens = [
    const HomeScreen(),
    const VehicleScreen(),
    const PlansScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
        selectedItemColor: const Color(0xffC68A00),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: "Vehicles",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Plans",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
