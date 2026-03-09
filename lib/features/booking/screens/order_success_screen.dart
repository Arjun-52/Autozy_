import 'package:autozy/features/booking/widget/order_details_card.dart';
import 'package:autozy/features/booking/widget/success_button.dart';
import 'package:autozy/features/booking/widget/success_icon.dart';
import 'package:flutter/material.dart';

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

            const SuccessIcon(),

            const SizedBox(height: 20),

            const Text(
              "Slot Booked!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your plan and slot has been booked\nsuccessfully",
              textAlign: TextAlign.center,

              style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 30),

            const OrderDetailsCard(),

            const Spacer(),

            SuccessButton(
              text: "Continue to Inspection",
              filled: true,
              onPressed: () {
                Navigator.pushNamed(context, '/inspection');
              },
            ),

            const SizedBox(height: 12),

            SuccessButton(
              text: "Go to Home",
              filled: false,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
