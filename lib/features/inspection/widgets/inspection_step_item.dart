import 'package:flutter/material.dart';
import '../models/inspection_step_model.dart';

class InspectionStepItem extends StatelessWidget {
  final InspectionStepModel step;

  const InspectionStepItem({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.teal,
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
              Container(width: 2, height: 40, color: Colors.teal),
            ],
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              Text(step.subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
