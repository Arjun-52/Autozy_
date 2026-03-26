import 'package:flutter/material.dart';

class PayButton extends StatelessWidget {
  final String price;
  final VoidCallback onPressed;

  const PayButton({super.key, required this.price, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),

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

            onPressed: onPressed,

            child: Text(
              "Pay ₹$price",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
