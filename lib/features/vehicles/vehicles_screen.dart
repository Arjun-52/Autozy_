import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_card.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          AppStrings.myVehicles,
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
                'Your Vehicles',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildVehicleCard(
                      'Honda Civic',
                      'ABC-1234',
                      'Sedan',
                      '2022',
                      'Active',
                    ),
                    _buildVehicleCard(
                      'Toyota Camry',
                      'XYZ-5678',
                      'Sedan',
                      '2021',
                      'Active',
                    ),
                    _buildVehicleCard(
                      'Ford F-150',
                      'DEF-9012',
                      'Truck',
                      '2020',
                      'Maintenance',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: AppStrings.addVehicle,
                onPressed: () {
                  Navigator.pushNamed(context, '/add-vehicle');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    String name,
    String number,
    String type,
    String year,
    String status,
  ) {
    Color statusColor = status == 'Active' ? AppColors.success : AppColors.warning;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        onTap: () {
          // Navigate to vehicle details
        },
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.directions_car,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$type • $year',
                    style: AppTextStyles.bodyText2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    number,
                    style: AppTextStyles.bodyText2,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
