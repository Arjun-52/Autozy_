import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/subscription_provider.dart';

class CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CheckoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final isLoading = subProvider.isLoading;

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

          onPressed: isLoading ? null : onPressed,

          child: isLoading
              ? const CircularProgressIndicator(color: Colors.black)
              : const Text(
                  "Proceed to Payment",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
