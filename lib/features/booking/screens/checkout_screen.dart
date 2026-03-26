import 'package:autozy/features/booking/widgets/booking_slot_card.dart';
import 'package:autozy/features/booking/widgets/checkout_button.dart';
import 'package:autozy/features/booking/widgets/plan_details_card.dart';
import 'package:autozy/features/booking/widgets/price_breakdown_card.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final String day;
  final String date;
  final String time;

  const CheckoutScreen({
    super.key,
    required this.day,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [
          /// MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  BookingSlotCard(day: day, date: date, time: time),

                  const SizedBox(height: 20),

                  const PlanDetailsCard(),

                  const SizedBox(height: 20),

                  const PriceBreakdownCard(),
                ],
              ),
            ),
          ),

          CheckoutButton(onPressed: () {}),
        ],
      ),
    );
  }
}
