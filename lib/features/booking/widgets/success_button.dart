import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class SuccessButton extends StatelessWidget {
  final String text;
  final bool filled;
  final VoidCallback onPressed;

  const SuccessButton({
    super.key,
    required this.text,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: SizedBox(
        width: double.infinity,
        height: context.h(46),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: filled ? const Color(0xffF4C430) : Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            side: filled ? null : const BorderSide(color: Color(0xffF4C430)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
