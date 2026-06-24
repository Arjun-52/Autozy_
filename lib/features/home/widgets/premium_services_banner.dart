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
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCB2F), // Matches the premium yellow
          borderRadius: BorderRadius.circular(20),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.flash_on_rounded,
                color: Color(0xFFFFCB2F),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            // Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Premium Services",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Interior Deep Cleaning\nCeramic Coating & More",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
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
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
