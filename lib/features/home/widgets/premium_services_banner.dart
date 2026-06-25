import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PremiumServicesBanner extends StatelessWidget {
  const PremiumServicesBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('bookAddon');
      },
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCB2F), // Matches the premium yellow
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFCB2F).withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Dark icon container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.flash_on_rounded,
                color: Color(0xFFFFCB2F),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Premium Services",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Interior Deep Cleaning\nCeramic Coating & More",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chevron arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
