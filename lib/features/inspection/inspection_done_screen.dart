import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/primary_button.dart';

class InspectionDoneScreen extends StatelessWidget {
  const InspectionDoneScreen({Key? key}) : super(key: key);

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
                AppStrings.inspectionDone,
                style: AppTextStyles.headline1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Vehicle inspection completed successfully\nAll systems are functioning properly',
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
                      'Inspection Summary',
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
                        Icon(Icons.check_circle, color: AppColors.success, size: 20),
                        const SizedBox(width: 12),
                        Text('8/10 items passed inspection', style: AppTextStyles.bodyText2),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.warning, color: AppColors.warning, size: 20),
                        const SizedBox(width: 12),
                        Text('2 items need attention', style: AppTextStyles.bodyText2),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Actions:',
                            style: AppTextStyles.bodyText2.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('• Replace battery within 3 months', style: AppTextStyles.bodyText2),
                          Text('• Check suspension components', style: AppTextStyles.bodyText2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                text: 'Download Report',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report downloaded successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Back to Home',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
