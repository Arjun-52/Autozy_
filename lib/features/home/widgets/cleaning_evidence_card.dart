import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/dto/home_dashboard_response.dart';

class CleaningEvidenceCard extends StatelessWidget {
  final TodayService? todayService;

  const CleaningEvidenceCard({
    super.key,
    this.todayService,
  });

  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void _showImagePreview(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Prefer the explicit before/after image fields the backend now returns;
    // fall back to the legacy `photos` array (photos[0]=before, photos[1]=after).
    final String? beforeImage = todayService?.beforeImage;
    final String? afterImage = todayService?.afterImage;
    final List<dynamic> photos = (beforeImage != null && beforeImage.isNotEmpty &&
            afterImage != null && afterImage.isNotEmpty)
        ? [beforeImage, afterImage]
        : (todayService?.photos ?? []);
    final String? completedAt = todayService?.completedAt;
    final bool hasPhotos = photos.length >= 2;

    final String status = todayService?.status.toUpperCase() ?? 'PENDING';
    String subtitle = "Cleaning has not started yet.";
    if (status == 'PENDING') {
      subtitle = "Cleaning has not started yet.";
    } else if (status == 'IN_PROGRESS' || status == 'IN-PROGRESS' || status == 'PROGRESS') {
      subtitle = "Your vehicle is currently being cleaned.";
    } else if (status == 'COMPLETED' || status == 'SUCCESS') {
      subtitle = "Cleaning completed successfully.";
    } else if (status == 'VERIFIED') {
      subtitle = "Cleaning verified by our quality team.";
    } else {
      subtitle = "No cleaning activity reported.";
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4F3FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Cleaning Evidence",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7E8392),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (!hasPhotos) ...[
            // Empty State
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9FB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Cleaning evidence will appear after your first completed service.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7E8392),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (completedAt != null && completedAt.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      "Completed at $completedAt",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            // Side-by-side Before/After
            Row(
              children: [
                // Before
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0E6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Before",
                          style: TextStyle(
                            color: Color(0xFFFF7A00),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showImagePreview(
                          context,
                          photos[0].toString(),
                          "Before Cleaning",
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: photos[0].toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade100,
                                child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFFFF7A00),
                  size: 16,
                ),
                const SizedBox(width: 8),
                // After
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4FFF2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "After",
                          style: TextStyle(
                            color: Color(0xFF008847),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showImagePreview(
                          context,
                          photos[1].toString(),
                          "After Cleaning",
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: photos[1].toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade100,
                                child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (completedAt != null && completedAt.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF008847)),
                  const SizedBox(width: 4),
                  Text(
                    "Service completed at $completedAt",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7E8392),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            // Service details block
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Date: ${todayService!.cleaningDate ?? 'Today'}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Time: ${todayService!.completedAt ?? 'Not completed'}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Detailer: ${todayService!.detailerName ?? 'Autozy Team'}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.design_services_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Type: ${todayService!.serviceType ?? 'Daily Clean'}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
