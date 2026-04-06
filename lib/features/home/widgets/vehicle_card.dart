import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161616).withValues(alpha: 0.12),
            blurRadius: 13,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCB2F),
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
                  Text(
                    "TS 01 AB 1234",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff7E8392),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              /// STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4FFF2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF008847)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF008847),
                      size: 16,
                    ),
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

          /// MESSAGE BOX
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "✨ Your car was cleaned today at 7:15 AM",
              style: TextStyle(fontSize: 12),
            ),
          ),

          const SizedBox(height: 10),

          /// WARNING TEXT
          const Text(
            "⚠️ If the car is not available at the scheduled time, Autozy is not responsible for the missed service.",
            style: TextStyle(color: Color(0xff7E8392), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
