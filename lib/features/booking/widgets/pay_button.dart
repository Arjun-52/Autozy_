import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class PayButton extends StatelessWidget {
  final String price;
  final VoidCallback onPressed;

  const PayButton({super.key, required this.price, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.w(16)),
        child: SizedBox(
          width: double.infinity,
          height: context.h(46),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF4C430),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              "Pay ₹$price",
              style: TextStyle(
                fontSize: context.sp(14),
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
