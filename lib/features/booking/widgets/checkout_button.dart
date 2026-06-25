import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/subscription_provider.dart';
import '../../../core/utils/responsive.dart';

class CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CheckoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final isLoading = subProvider.isLoading;

    return Container(
      padding: EdgeInsets.fromLTRB(context.w(16), context.h(10), context.w(16), context.h(20)),
      child: SizedBox(
        width: double.infinity,
        height: context.h(46),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFCB2F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                )
              : Text(
                  "Proceed to Payment",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
