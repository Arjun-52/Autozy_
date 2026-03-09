import 'package:flutter/material.dart';

class StandardPlanActiveCard extends StatelessWidget {
  const StandardPlanActiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFF6A800),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,

            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 12),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Standard Plan Active",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              SizedBox(height: 2),

              Text(
                "Your daily car care has started!",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
