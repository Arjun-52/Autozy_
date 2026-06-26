import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class VerifyButton extends StatelessWidget {
  final Future<void> Function()? onPressed;

  const VerifyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.h(46),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
  "Verify & Continue",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Poppins',
    fontSize: context.sp(14),
    fontWeight: FontWeight.w600,
    color: Colors.black,
    height: 1.0,
  ),
),
            SizedBox(width: context.w(6)),
            Icon(
              Icons.arrow_forward,
              size: context.sp(18),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
