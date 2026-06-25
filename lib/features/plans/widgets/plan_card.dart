import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? description;
  final List<Map<String, dynamic>> features;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget icon;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    this.description,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xffF4C430)
                : const Color(0xFFE9E9E9),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF161616).withValues(alpha: 0.08),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
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
              const SizedBox(height: 8),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /// ICON CONTAINER
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFCB2F)
                              : const Color(0xFFFFECBC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: icon,
                      ),
                      const SizedBox(width: 10),
                      /// TITLE + PRICE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  price,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Text(
                                  " /month",
                                  style: TextStyle(
                                    color: Color(0xFF7E8392),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            if (description != null && description!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                description!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF7E8392),
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                /// SELECTED CHECK CIRCLE
                Container(
                  width: 24,
                  height: 24,
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
                      ? const Icon(Icons.check, size: 14, color: Colors.black)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: features.map((f) {
                final isSelected = f["isSelected"] as bool;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: 14,
                        color: isSelected
                            ? const Color(0xFFFFCB2F)
                            : const Color(0xFF7E8392),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        f["title"] as String,
                        style: TextStyle(
                          fontSize: 11,
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
