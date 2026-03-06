import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/primary_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.orderSuccess,
                style: AppTextStyles.headline1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your booking has been confirmed\nWe\'ll send you a confirmation email shortly',
                style: AppTextStyles.bodyText1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: AppTextStyles.headline3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.directions_car, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Text('Honda Civic - ABC-1234', style: AppTextStyles.bodyText2),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Text('15 March 2024', style: AppTextStyles.bodyText2),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Text('10:00 AM', style: AppTextStyles.bodyText2),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Text('Autozy Service Center', style: AppTextStyles.bodyText2),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                text: 'Back to Home',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/invoices');
                },
                child: Text(
                  'View Invoice',
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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
