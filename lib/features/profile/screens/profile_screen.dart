import 'package:autozy/core/constants/colors.dart';
import 'package:autozy/features/profile/widgets/menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/navigation_helper.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchUserProfile();
      context.read<NotificationProvider>().fetchUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profile = authProvider.profile;
    final user = authProvider.user;

    final displayName = profile?.name.isNotEmpty == true 
        ? profile!.name 
        : (user?.name.isNotEmpty == true ? user!.name : "User");
    final displayPhone = profile?.phone.isNotEmpty == true 
        ? profile!.phone 
        : (user?.phone.isNotEmpty == true ? user!.phone : "");

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
            context.go('/home?initialIndex=0');
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await authProvider.fetchUserProfile();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "+91 $displayPhone",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff7E8392),
                              ),
                            ),
                            if (profile != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                "Registered Vehicles: ${profile.vehicleCount}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.brandOrange,
                                ),
                              ),
                            ]
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
                  'assets/images/view_plans.svg',
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
                title: "My Subscriptions",
                onTap: () => context.pushNamed('subscriptions'),
              ),
              MenuTile(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 24,
                  color: Colors.black87,
                ),
                title: "My Add-on Bookings",
                onTap: () {
                  context.push('/addon-bookings');
                },
              ),
              MenuTile(
                icon: const Icon(
                  Icons.confirmation_number_outlined,
                  size: 24,
                  color: Colors.black87,
                ),
                title: "My Support Tickets",
                onTap: () {
                  context.push('/tickets');
                },
              ),
              MenuTile(
                icon: SvgPicture.asset(
                  'assets/images/notification.svg',
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
                title: "Notifications",
                badgeCount: context.watch<NotificationProvider>().unreadCount,
                onTap: () async {
                  await context.push('/notifications');
                  if (context.mounted) {
                    context.read<NotificationProvider>().fetchUnreadCount();
                  }
                },
              ),
              const SizedBox(height: 20),

              /// LOGOUT
              GestureDetector(
                onTap: () async {
                  final router = GoRouter.of(context);
                  await authProvider.logout();
                  router.go('/login');
                },
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
                    color: const Color(0xFFEEEEEE),
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
                      const SizedBox(height: 12),
                      const Text(
                        "autozy",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff363636),
                        ),
                      ),
                      const Text(
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
      ),
    );
  }
}
