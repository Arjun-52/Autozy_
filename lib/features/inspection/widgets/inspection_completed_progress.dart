import 'package:flutter/material.dart';
import '../models/inspection_step_model.dart';

class InspectionCompletedProgressCard extends StatelessWidget {
  const InspectionCompletedProgressCard({super.key});

  List<InspectionStepModel> get steps => const [
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Inspection Progress",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            steps.length,
            (index) => _CompletedProgressItem(
              step: steps[index],
              isLast: index == steps.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedProgressItem extends StatelessWidget {
  final InspectionStepModel step;
  final bool isLast;

  const _CompletedProgressItem({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),

                if (!isLast)
                  Container(
                    width: 2,
                    height: 44,
                    color: const Color(0xFF148C81),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(step.subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
