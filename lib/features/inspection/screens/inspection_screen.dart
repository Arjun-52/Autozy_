import 'package:autozy/features/home/widgets/home_bottom_nav.dart';
import 'package:autozy/features/inspection/screens/inspection_done_screen.dart';
import 'package:autozy/features/inspection/widgets/arrival_timer_card.dart';
import 'package:autozy/features/inspection/widgets/inspection_info_box.dart';
import 'package:autozy/features/inspection/widgets/inspection_progress_card.dart';
import 'package:autozy/features/inspection/widgets/inspection_completed_card.dart';
import 'package:flutter/material.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key});

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  bool inspectionCompleted = false;

  void onTimerFinished() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InspectionDoneScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

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

            inspectionCompleted
                ? const InspectionCompletedCard()
                : const InspectionProgressCard(),

            const SizedBox(height: 20),

            const InspectionInfoBox(),
          ],
        ),
      ),

      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
