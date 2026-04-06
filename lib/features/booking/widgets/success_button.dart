import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: SizedBox(
        width: double.infinity,
        height: 60,

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: filled ? const Color(0xffF4C430) : Colors.white,
            foregroundColor: Colors.black,
            elevation: filled ? 0 : 0,

            side: filled ? null : const BorderSide(color: Color(0xffF4C430)),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),

          onPressed: onPressed,

          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
