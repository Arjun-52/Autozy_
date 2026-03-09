import 'package:flutter/material.dart';
import '../models/inspection_step_model.dart';

class InspectionProgressCard extends StatelessWidget {
  const InspectionProgressCard({super.key});

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
      completed: false,
    ),
    InspectionStepModel(
      title: "Inspection Approved",
      subtitle: "Vehicle cleared for service",
      completed: false,
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
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Inspection Progress",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            steps.length,
            (index) => _ProgressItem(
              step: steps[index],
              isLast: index == steps.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final InspectionStepModel step;
  final bool isLast;

  const _ProgressItem({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Timeline Column
          SizedBox(
            width: 32,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: step.completed
                      ? Colors.teal
                      : const Color(0xFFD1D1D1),
                  child: step.completed
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : const Icon(Icons.circle, size: 10),
                ),

                if (!isLast)
                  Container(
                    width: 2,
                    height: 48,
                    color: step.completed
                        ? const Color(0xFF148C81)
                        : const Color(0xFFD1D1D1),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// Text Section
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
