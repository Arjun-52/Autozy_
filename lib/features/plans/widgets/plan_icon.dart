import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class PlanIcon extends StatelessWidget {
  final IconData icon;

  const PlanIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppColors.primary, size: 26),
    );
  }
}
