import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' show BlendMode, ColorFilter;

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
      unselectedItemColor: const Color(0xFF8E8E93),

      showUnselectedLabels: true,
      showSelectedLabels: true,

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
          icon: Builder(
            builder: (context) {
              final tint = IconTheme.of(context).color ?? const Color(0xFF8E8E93);
              return SvgPicture.asset(
                'assets/images/car2.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
              );
            },
          ),
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
