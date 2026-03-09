import 'package:flutter/material.dart';

class InspectionNoticeCard extends StatelessWidget {
  const InspectionNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange),
      ),

      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.orange),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              "Service begins only after inspection is approved. "
              "Your first wash will be scheduled for the next available slot.",
            ),
          ),
        ],
      ),
    );
  }
}
