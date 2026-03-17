import 'package:flutter/material.dart';

/// Reusable back button used throughout the app
class AppBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const AppBackButton({
    super.key,
    this.color = Colors.black,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color),
      onPressed: onPressed ?? () => Navigator.pop(context),
    );
  }
}
