import 'package:autozy/core/constants/colors.dart';
import 'package:autozy/features/profile/widgets/menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/navigation_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            print("Before back, route: ${GoRouterState.of(context).uri}");

            context.go('/home?initialIndex=0');
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// USER CARD
            InkWell(
              onTap: () {
                NavigationHelper.safeNavigate(context, 'editProfile');
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
                        color: AppColors.brandYellow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                            'assets/images/profile.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "+91 9123456789",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff7E8392),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// MENU ITEMS
            MenuTile(
              icon: SvgPicture.asset(
                'assets/images/location.svg',
                height: 24,
                width: 24,
                fit: BoxFit.contain,
              ),
              title: "Saved Addresses",
              onTap: () {
                context.push('/saved-address');
              },
            ),
            MenuTile(
              icon: SvgPicture.asset(
                'assets/images/bills.svg',
                height: 24,
                width: 24,
                fit: BoxFit.contain,
              ),
              title: "Invoices & Bills",
              onTap: () => context.pushNamed('invoices'),
            ),
            MenuTile(
              icon: SvgPicture.asset(
                'assets/images/notification.svg',
                height: 24,
                width: 24,
                fit: BoxFit.contain,
              ),
              title: "Notifications",
              showBadge: true,
              onTap: () {
                context.push('/notifications');
              },
            ),

            const SizedBox(height: 20),

            /// LOGOUT
            GestureDetector(
              onTap: () => context.go('/login'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(7),
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
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// APP INFO
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/new-logo.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "autozy",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff363636),
                      ),
                    ),
                    Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff7E8392),
                      ),
                    ),
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
