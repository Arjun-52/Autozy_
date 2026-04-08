import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<Map<String, dynamic>> features;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget icon;

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

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: isSelected
                ? const Color(0xffF4C430)
                : const Color(0xFFE9E9E9),
            width: isSelected ? 2 : 1,
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFF161616).withValues(alpha: 0.12),
              blurRadius: 13,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
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
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
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
                      child: icon,
                    ),

                    const SizedBox(width: 12),

                    /// TITLE + PRICE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              " /month",
                              style: TextStyle(
                                color: Color(0xFF7E8392),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                /// SELECTED CHECK CIRCLE
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFFFFCB2F) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFFCB2F)
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.black)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),

            Column(
              children: features.map((f) {
                final isSelected = f["isSelected"] as bool;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: 18,
                        color: isSelected
                            ? const Color(0xFFFFCB2F)
                            : const Color(0xFF7E8392),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        f["title"] as String,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFF7E8392),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
