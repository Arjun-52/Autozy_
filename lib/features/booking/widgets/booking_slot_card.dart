import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

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
    final parts = [day, date, time].where((e) => e.trim().isNotEmpty).toList();
    final label = parts.isEmpty ? 'No slot selected' : parts.join(', ');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(11)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: context.w(20),
            color: const Color(0xff7E8392),
          ),
          SizedBox(width: context.w(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Booking Slot",
                  style: TextStyle(
                    color: const Color(0xff7E8392),
                    fontSize: context.sp(11),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: context.h(2)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.sp(12.5),
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
