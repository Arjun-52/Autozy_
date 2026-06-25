import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/dto/home_dashboard_response.dart';

class VehicleStatusCard extends StatelessWidget {
  final Vehicle? vehicle;
  final TodayService? todayService;
  final HomeSubscription? subscription;

  const VehicleStatusCard({
    super.key,
    this.vehicle,
    this.todayService,
    this.subscription,
  });

  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (vehicle == null) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9E9E9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/images/car2.svg',
                height: 30,
                width: 30,
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "No Active Vehicles",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 2),
            const Text(
              "Add a vehicle to manage its daily service",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF7E8392)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed('vehicles');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCB2F),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Add Vehicle", style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    }

    final String brandModel = "${vehicle!.brand} ${vehicle!.model}";
    final String number = vehicle!.vehicleNumber;
    final String planName = subscription != null
        ? "${_toTitleCase(subscription!.plan)} Plan"
        : "Standard Monthly Plan";

    // Dynamic completion status
    String todayCleanText = "Pending";
    String? todayCleanDesc = "No cleaning service completed yet";

    if (todayService != null) {
      if (todayService!.status.toUpperCase() == "CLEANED") {
        todayCleanText = "Completed at ${todayService!.completedAt ?? ''}";
        todayCleanDesc = null;
      } else if (todayService!.completedAt != null && todayService!.completedAt!.isNotEmpty) {
        todayCleanText = "Completed at ${todayService!.completedAt}";
        todayCleanDesc = null;
      } else if (todayService!.status.toLowerCase() == 'completed') {
        todayCleanText = "Completed";
        todayCleanDesc = null;
      } else if (todayService!.status.toLowerCase() == 'pending') {
        todayCleanText = "Pending";
        todayCleanDesc = "No cleaning service completed yet";
      } else {
        todayCleanText = "Status: ${_toTitleCase(todayService!.status)}";
        todayCleanDesc = null;
      }
    }

    String nextCleanText = "Tomorrow";
    if (todayService != null && todayService!.nextCleaning != null && todayService!.nextCleaning!.isNotEmpty) {
      nextCleanText = todayService!.nextCleaning!;
    } else if (subscription != null && subscription!.nextCleaning != null && subscription!.nextCleaning!.isNotEmpty) {
      nextCleanText = subscription!.nextCleaning!;
    } else {
      nextCleanText = "Not Scheduled";
    }

    final String status = vehicle!.status.toUpperCase();
    String badgeText = status;
    Color badgeBg = const Color(0xFFF5F5F5);
    Color badgeColor = Colors.grey;

    if (status == 'PENDING') {
      badgeText = "Inspection Pending";
      badgeBg = const Color(0xFFFFF9E6);
      badgeColor = const Color(0xFFDD900C);
    } else if (status == 'APPROVED') {
      badgeText = "Approved";
      badgeBg = const Color(0xFFE4FFF2);
      badgeColor = const Color(0xFF008847);
    } else if (status == 'REJECTED') {
      badgeText = "Rejected";
      badgeBg = const Color(0xFFFFEBEA);
      badgeColor = const Color(0xFFFF3B30);
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle image placeholder/avatar matching the Hyundai Creta mockup visual
                Container(
                  width: 72,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: vehicle!.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: vehicle!.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                'assets/images/car2.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/images/car2.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Vehicle Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              brandModel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Approval Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: badgeColor, width: 1),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                color: badgeColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        number,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8E8E93),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Active Subscription Name Row
                      Row(
                        children: [
                          Icon(
                            status == 'APPROVED' ? Icons.check_circle_rounded : Icons.pending_rounded,
                            color: badgeColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              status == 'APPROVED' ? planName : "Pending Approval",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7E8392),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (status == 'APPROVED') ...[
            const Divider(height: 1, color: Color(0xFFE9E9E9)),
            if (subscription != null)
              // Bottom Clean Row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.wb_sunny_rounded, size: 14, color: Color(0xFFFFCB2F)),
                              SizedBox(width: 4),
                              Text(
                                "Today's Cleaning:",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            todayCleanText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (todayCleanDesc != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              todayCleanDesc,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF7E8392),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      height: 28,
                      width: 1,
                      color: const Color(0xFFE9E9E9),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.wb_sunny_rounded, size: 14, color: Color(0xFFFFCB2F)),
                              SizedBox(width: 4),
                              Text(
                                "Next Cleaning:",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            nextCleanText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7E8392),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text(
                  "Service schedule will appear here once your subscription becomes active.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7E8392),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
