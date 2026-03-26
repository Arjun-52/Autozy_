import 'package:flutter/material.dart';

class InspectionSuccessCard extends StatelessWidget {
  const InspectionSuccessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFF6C431),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: const [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green,
            child: Icon(Icons.check, color: Colors.white, size: 30),
          ),

          SizedBox(height: 12),

          Text(
            "Inspection Complete!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 6),

          Text(
            "Your Standard plan service will start soon",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
