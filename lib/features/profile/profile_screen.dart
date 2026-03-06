import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          AppStrings.profile,
          style: AppTextStyles.headline2,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.person,
                        color: AppColors.onPrimary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: AppTextStyles.headline3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'john.doe@example.com',
                            style: AppTextStyles.bodyText2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+1 234 567 8900',
                            style: AppTextStyles.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit-profile');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Account Settings',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  children: [
                    _buildProfileOption(
                      'Personal Information',
                      Icons.person,
                      () => Navigator.pushNamed(context, '/edit-profile'),
                    ),
                    const Divider(),
                    _buildProfileOption(
                      'My Vehicles',
                      Icons.directions_car,
                      () => Navigator.pushNamed(context, '/vehicles'),
                    ),
                    const Divider(),
                    _buildProfileOption(
                      'Booking History',
                      Icons.history,
                      () => Navigator.pushNamed(context, '/bookings'),
                    ),
                    const Divider(),
                    _buildProfileOption(
                      'Payment Methods',
                      Icons.payment,
                      () {},
                    ),
                    const Divider(),
                    _buildProfileOption(
                      'Notifications',
                      Icons.notifications,
                      () {},
                    ),
                    const Divider(),
                    _buildProfileOption(
                      'Privacy & Security',
                      Icons.security,
                      () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Support',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  children: [
                    _buildProfileOption(
                      'Help Center',
                      Icons.help,
                      () {},
                    ),
                    const Divider(),
                    _buildProfileOption(
                      'Terms & Conditions',
                      Icons.description,
                      () {},
                    ),
                    const Divider(),
                    _buildProfileOption(
                      'About',
                      Icons.info,
                      () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomCard(
                child: _buildProfileOption(
                  'Logout',
                  Icons.logout,
                  () {
                    _showLogoutDialog(context);
                  },
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: color ?? AppColors.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyText1.copyWith(
                  color: color ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
