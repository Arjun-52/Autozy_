import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFFCB2F).withValues(alpha: .9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'assets/images/car2.svg',
                  height: 20,
                  width: 20,
                ),
              ),

              const SizedBox(width: 12),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hyundai Creta",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text("TS 01 AB 1234"),
                ],
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE4FFF2).withValues(alpha: 1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFF008847).withValues(alpha: 0.8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),

                    SizedBox(width: 4),

                    Text(
                      "Cleaned",
                      style: TextStyle(
                        color: Color(0xFF008847),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("✨ Your car was cleaned today at 7:15 AM"),
          ),

          const SizedBox(height: 10),

          const Text(
            "⚠️ If the car is not available at the scheduled time, Autozy is not responsible for the missed service.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
