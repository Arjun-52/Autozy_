import 'package:autozy/features/inspection/screens/inspection_done_screen.dart';
import 'package:autozy/features/inspection/screens/inspection_screen.dart';
import 'package:autozy/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/vehicles/screens/vehicles_screen.dart';
import '../../features/plans/screens/plans_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final bool showPlanActiveCard;
  final String? screen;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.showPlanActiveCard = false,
    this.screen,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> screens = [
    const HomeScreen(),
    const VehicleScreen(),
    const PlansScreen(),
    const ProfileScreen(),
  ];

  void onTabTapped(int index) {
    // Drive tab changes through routing so UI always matches the URL.
    context.go('/home?initialIndex=$index');
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.initialIndex;
    print("MainScreen build, route: ${GoRouterState.of(context).uri}");
    return Scaffold(
      body: () {
        if (widget.screen == 'inspection') {
          return const InspectionScreen();
        } else if (widget.screen == 'inspectionDone') {
          return const InspectionDoneScreen();
        }

        return currentIndex == 0
            ? HomeScreen(showPlanActiveCard: widget.showPlanActiveCard)
            : screens[currentIndex];
      }(),

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
