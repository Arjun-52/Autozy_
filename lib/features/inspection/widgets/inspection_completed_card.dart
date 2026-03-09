import 'package:flutter/material.dart';
import '../models/inspection_step_model.dart';
import 'inspection_step_item.dart';

class InspectionCompletedCard extends StatelessWidget {
  const InspectionCompletedCard({super.key});

  @override
  Widget build(BuildContext context) {

    final steps = [
      InspectionStepModel(
        title: "Inspection Scheduled",
        subtitle: "Our inspector will visit soon",
        completed: true,
      ),
      InspectionStepModel(
        title: "Inspection In Progress",
        subtitle: "Inspector is checking your vehicle",
        completed: true,
      ),
      InspectionStepModel(
        title: "Photos Captured",
        subtitle: "Before-service photos documented",
        completed: true,
      ),
      InspectionStepModel(
        title: "Inspection Approved",
        subtitle: "Vehicle cleared for service",
        completed: true,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Inspection Progress",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ...steps.map((step) => InspectionStepItem(step: step)),
        ],
      ),
    );
  }
}