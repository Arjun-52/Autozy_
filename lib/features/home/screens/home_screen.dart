import 'package:autozy/features/home/widgets/standard_plan_active_card.dart';

import '../widgets/explore_card.dart.dart';
import '../widgets/greeting_section.dart';
import '../widgets/home_header.dart';
import '../widgets/premium_services_card.dart';
import '../widgets/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.showPlanActiveCard = false});
  final bool showPlanActiveCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E3),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: ListView(
            children: [
              const HomeHeader(),

              const SizedBox(height: 20),

              const GreetingSection(),

              const SizedBox(height: 20),
              if (showPlanActiveCard) const StandardPlanActiveCard(),

              const VehicleCard(),

              const SizedBox(height: 26),

              const Text(
                "Explore",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ExploreCard(
                      icon: Icons.description_outlined,
                      title: "View Plans",
                      onTap: () {
                        context.pushNamed('plans');
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ExploreCard(
                      icon: Icons.add_circle_outline,
                      title: "Add Vehicle",
                      onTap: () {
                        context.pushNamed('vehicles');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              ExploreCard(
                icon: Icons.calendar_today_outlined,
                title: "Book Slot",
                fullWidth: true,
                onTap: () {
                  context.pushNamed('bookSlot');
                },
              ),

              const SizedBox(height: 20),

              const PremiumServicesCard(),
            ],
          ),
        ),
      ),
    );
  }
}
