import 'package:autozy/core/router/app_router.dart';
import 'package:flutter/material.dart';

class CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CheckoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),

      child: SizedBox(
        width: double.infinity,
        height: 60,

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffF4C430),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),

          onPressed: () {
            Navigator.pushNamed(context, AppRouter.payment);
          },

          child: const Text(
            "Proceed to Payment",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
