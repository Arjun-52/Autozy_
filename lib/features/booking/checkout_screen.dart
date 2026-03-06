import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_card.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          AppStrings.checkout,
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
                'Booking Summary',
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
                'Service Details',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Standard Service Plan', style: AppTextStyles.headline3),
                    const SizedBox(height: 8),
                    Text('Complete vehicle inspection and maintenance', style: AppTextStyles.bodyText2),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: AppTextStyles.bodyText1),
                        Text('\$49.99', style: AppTextStyles.bodyText1),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tax', style: AppTextStyles.bodyText2),
                        Text('\$5.00', style: AppTextStyles.bodyText2),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTextStyles.headline3),
                        Text('\$54.99', style: AppTextStyles.headline3.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Proceed to Payment',
                onPressed: () {
                  Navigator.pushNamed(context, '/payment');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
