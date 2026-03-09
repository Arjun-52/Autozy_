import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF5E6C8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Slots must be booked at least 48 hours in advance. Availability depends on area capacity.",
            ),
          ),
        ],
      ),
    );
  }
}
