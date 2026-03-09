import 'package:autozy/features/home/widgets/home_bottom_nav.dart';
import 'package:autozy/features/inspection/widgets/arrival_timer_card.dart';
import 'package:autozy/features/inspection/widgets/inspection_info_box.dart';
import 'package:autozy/features/inspection/widgets/inspection_progress_card.dart';
import 'package:flutter/material.dart';

class InspectionScreen extends StatelessWidget {
  const InspectionScreen({super.key});

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
          children: const [
            ArrivalTimerCard(),

            SizedBox(height: 20),

            InspectionProgressCard(),

            SizedBox(height: 20),

            InspectionInfoBox(),
          ],
        ),
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
