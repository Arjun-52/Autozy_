import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xffF4C430) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF4C430),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Most Popular",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    /// ICON CONTAINER
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFCB2F)
                            : const Color(0xFFFFECBC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: Colors.black, size: 26),
                    ),

                    const SizedBox(width: 12),

                    /// TITLE + PRICE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              " /month",
                              style: TextStyle(color: Color(0xFF7E8392)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                /// SELECTED CHECK CIRCLE
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isSelected
                      ? const Color(0xffF4C430)
                      : Colors.grey[300],
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.black)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),

            Column(
              children: features
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check,
                            size: 18,
                            color: Color(0xffC68A00),
                          ),
                          const SizedBox(width: 8),
                          Text(f),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
