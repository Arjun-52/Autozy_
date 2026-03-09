import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Plan Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffF4C430),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.auto_awesome),
              ),

              const SizedBox(width: 14),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Standard",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(height: 4),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "₹799 /",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: "month",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
