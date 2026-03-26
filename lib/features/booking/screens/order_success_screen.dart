import 'package:autozy/features/booking/widgets/order_details_card.dart';
import 'package:autozy/features/booking/widgets/success_button.dart';
import 'package:autozy/features/booking/widgets/success_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            SuccessIcon(),

            const SizedBox(height: 20),

            const Text(
              "Slot Booked!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your plan and slot has been booked\nsuccessfully",
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            OrderDetailsCard(),

            const Spacer(),
            SuccessButton(
              text: "Continue to Inspection",
              filled: true,
              onPressed: () {
                context.push('/inspection');
              },
            ),

            const SizedBox(height: 12),

            SuccessButton(
              text: "Go to Home",
              filled: false,
              onPressed: () {
                context.go('/home');
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
