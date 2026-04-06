import 'package:flutter/material.dart';

class BookingSlotCard extends StatelessWidget {
  final String day;
  final String date;
  final String time;

  const BookingSlotCard({
    super.key,
    required this.day,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ✅ fill

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16), // ✅ fixed

        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161616).withOpacity(0.12), // ✅ exact
            blurRadius: 13,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            size: 20, // ✅ adjusted
            color: Color(0xff7E8392),
          ),

          const SizedBox(width: 16), // ✅ exact gap

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // ✅ prevents overflow
              children: [
                const Text(
                  "Booking Slot", // ✅ unchanged
                  style: TextStyle(
                    color: Color(0xff7E8392),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Thursday, Mar 09, 08:00 - 13:00", // ✅ unchanged
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
