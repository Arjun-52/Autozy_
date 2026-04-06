import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool fullWidth;

  const ExploreCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isSelected = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 161,

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: const Color(0xFFE9E9E9), width: 1),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFF161616).withOpacity(0.12),
              blurRadius: 13,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: fullWidth
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            /// ICON BOX
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFC107)
                    : const Color(0xFFFFECBC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: icon,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: fullWidth ? TextAlign.center : TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
