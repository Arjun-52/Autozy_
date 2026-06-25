import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(10)),
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: const Color(0xffF5E6C8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 0.8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: context.w(20)),
          SizedBox(width: context.w(8)),
          Expanded(
            child: Text(
              "Slots must be booked at least 48 hours in advance. Availability depends on area capacity.",
              style: TextStyle(
                color: const Color(0xFF3E4347),
                fontSize: context.sp(10.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
