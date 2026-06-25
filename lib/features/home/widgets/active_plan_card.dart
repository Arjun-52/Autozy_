import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/dto/home_dashboard_response.dart';

class ActivePlanCard extends StatelessWidget {
  final HomeSubscription? subscription;
  final bool hasVehicle;

  const ActivePlanCard({
    super.key,
    this.subscription,
    required this.hasVehicle,
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
    // If no vehicle exists, we hide the card entirely
    if (!hasVehicle) {
      return const SizedBox.shrink();
    }

    final String status = subscription?.status.toUpperCase() ?? 'NONE';

    // If subscription is expired, cancelled, or doesn't exist, show "Choose a Plan" state
    if (status == 'NONE' || status == 'EXPIRED' || status == 'CANCELLED') {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9E9E9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Plan Icon
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF9E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_outline_rounded,
                color: Color(0xFFFFCB2F),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "No Active Subscription",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Choose a plan to start daily service",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7E8392),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // View Plans Button
            ElevatedButton(
              onPressed: () {
                context.pushNamed('plans');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCB2F),
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                "View Plans",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final rawPlanName = subscription!.plan;
    final String planName = "${_toTitleCase(rawPlanName)} Plan";
    final expiryDate = subscription!.endDate;
    final subscriptionId = subscription!.id;

    // Card Colors & Icons based on status
    Color cardColor = const Color(0xFFFFCB2F);
    Color textColor = Colors.black;
    Color buttonColor = Colors.white;
    Color buttonTextColor = Colors.black;
    Widget statusIcon = const Icon(Icons.check_rounded, color: Colors.white, size: 20);
    Color iconBg = const Color(0xFF008847);
    String statusTitle = "$planName Active";
    String dateLabel = "Valid until $expiryDate";
    String buttonText = "Details";

    if (status == 'PAUSED') {
      cardColor = const Color(0xFFF2F2F7);
      textColor = Colors.black87;
      buttonColor = const Color(0xFFFFCB2F);
      buttonTextColor = Colors.black;
      statusIcon = const Icon(Icons.pause_rounded, color: Colors.white, size: 20);
      iconBg = Colors.grey;
      statusTitle = "$planName Paused";
      buttonText = "Resume";
    } else if (status == 'PENDING') {
      cardColor = const Color(0xFFFFF9E6);
      textColor = Colors.black87;
      buttonColor = Colors.white;
      buttonTextColor = Colors.black;
      statusIcon = const Icon(Icons.pending_actions_rounded, color: Colors.white, size: 20);
      iconBg = const Color(0xFFDD900C);
      statusTitle = "$planName Pending";
      dateLabel = "Activation pending";
      buttonText = "Details";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: status == 'ACTIVE'
            ? [
                BoxShadow(
                  color: const Color(0xFFFFCB2F).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          // Circular Status Icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: statusIcon,
          ),
          const SizedBox(width: 12),
          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled_rounded,
                      size: 14,
                      color: textColor.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Action Button
          ElevatedButton(
            onPressed: () {
              context.push('/subscription-details/$subscriptionId');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: buttonTextColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
