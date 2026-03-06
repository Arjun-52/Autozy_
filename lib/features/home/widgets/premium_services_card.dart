import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class PremiumServicesCard extends StatelessWidget {
  const PremiumServicesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.flash_on, color: Colors.white),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Premium Services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Interior deep cleaning, ceramic coating & more"),
              ],
            ),
          ),

          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
