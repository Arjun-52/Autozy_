import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final bool fullWidth;
  final VoidCallback? onTap;
  final bool isSelected;

  const ExploreCard({
    super.key,
    required this.icon,
    required this.title,
    this.fullWidth = false,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: fullWidth
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFC107) // selected
                    : const Color(0xFFFFECBC), // not selected
                borderRadius: BorderRadius.circular(10),
              ),
              child: icon,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
