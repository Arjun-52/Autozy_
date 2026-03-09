import 'package:autozy/features/home/widgets/home_bottom_nav.dart';
import 'package:autozy/features/inspection/widgets/inspection_completed_progress.dart';
import 'package:flutter/material.dart';

import '../widgets/inspection_success_card.dart';

import '../widgets/inspection_photos_grid.dart';
import '../widgets/inspection_notice_card.dart';
import '../widgets/inspection_home_button.dart';

class InspectionDoneScreen extends StatelessWidget {
  const InspectionDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Inspection", style: TextStyle(color: Colors.black)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),

        child: Column(
          children: [
            const InspectionSuccessCard(),

            const SizedBox(height: 20),

            InspectionCompletedProgressCard(),

            const SizedBox(height: 20),

            const InspectionPhotosGrid(),

            const SizedBox(height: 20),

            const InspectionNoticeCard(),

            const SizedBox(height: 20),

            const InspectionHomeButton(),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(),
    );
  }
}
