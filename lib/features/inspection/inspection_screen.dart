import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_card.dart';

class InspectionScreen extends StatelessWidget {
  const InspectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          AppStrings.inspection,
          style: AppTextStyles.headline2,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vehicle Inspection',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_car, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text('Honda Civic - ABC-1234', style: AppTextStyles.bodyText1),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text('15 March 2024', style: AppTextStyles.bodyText1),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text('10:00 AM', style: AppTextStyles.bodyText1),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Inspection Checklist',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildChecklistItem('Engine Oil Level', true),
                    _buildChecklistItem('Brake Pads', true),
                    _buildChecklistItem('Tire Pressure', true),
                    _buildChecklistItem('Battery Health', false),
                    _buildChecklistItem('Air Filter', true),
                    _buildChecklistItem('Coolant Level', true),
                    _buildChecklistItem('Transmission Fluid', false),
                    _buildChecklistItem('Lights & Signals', true),
                    _buildChecklistItem('Wiper Blades', true),
                    _buildChecklistItem('Suspension', false),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Complete Inspection',
                onPressed: () {
                  Navigator.pushNamed(context, '/inspection-done');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? AppColors.success : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyText1.copyWith(
                  color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
            if (isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'OK',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
