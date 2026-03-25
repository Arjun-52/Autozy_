import 'package:autozy/core/constants/colors.dart';
import 'package:autozy/features/inspection/widgets/arrival_timer_card.dart';
import 'package:autozy/features/inspection/widgets/inspection_info_box.dart';
import 'package:autozy/features/inspection/widgets/inspection_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key});

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  void onTimerFinished() {
    context.go('/inspection-done');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      appBar: AppBar(
        title: const Text("Inspection"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// TIMER CARD
            ArrivalTimerCard(onTimerFinished: onTimerFinished),

            const SizedBox(height: 20),

            const InspectionProgressCard(),

            const SizedBox(height: 20),

            const InspectionInfoBox(),
          ],
        ),
      ),
    );
  }
}
