import 'package:flutter/material.dart';

class InspectionInfoBox extends StatelessWidget {
  const InspectionInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xffFFF4E5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange),
      ),

      child: const Row(
        children: [
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
