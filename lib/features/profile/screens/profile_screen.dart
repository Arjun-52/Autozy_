import 'package:autozy/features/profile/widgets/menu_tile.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/navigation_helper.dart';
import 'invoices_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// USER CARD
            InkWell(
              onTap: () {
                // Safe navigation - ready for GoRouter migration
                NavigationHelper.safeNavigate(context, 'editProfile');

                // Original navigation (preserved for safety):
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const EditProfileScreen(),
                //   ),
                // );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6C431),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.person),
                    ),
                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "John Kevin",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("+91 9123456789"),
                        ],
                      ),
                    ),

                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// MENU ITEMS
            MenuTile(
              icon: Icons.location_on_outlined,
              title: "Saved Addresses",
            ),
            MenuTile(
              icon: Icons.receipt_long_outlined,
              title: "Invoices & Bills",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvoicesScreen(),
                  ),
                );
              },
            ),
            MenuTile(icon: Icons.notifications_none, title: "Notifications"),

            const SizedBox(height: 20),

            /// LOGOUT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// APP INFO
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, size: 50, color: Colors.amber),
                    SizedBox(height: 12),
                    Text(
                      "autozy",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
