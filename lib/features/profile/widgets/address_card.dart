import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final VoidCallback? onTap;

  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(11),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.orange, size: 20),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(13)),
                  ),
                  const SizedBox(height: 2),
                  Text(address, style: TextStyle(color: Colors.grey, fontSize: context.sp(11.5), fontWeight: FontWeight.w400)),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}
