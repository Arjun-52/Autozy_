import 'package:flutter/material.dart';

/// Reusable primary button used throughout the app
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final bool isLoading;
  final Widget? child;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height = 50,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 16,
    this.isLoading = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xffF4C430),
          foregroundColor: textColor ?? Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : child ??
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }
}
