import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../providers/vehicle_provider.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchUnreadCount();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning 👋";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon 👋";
    } else {
      return "Good Evening 👋";
    }
  }

  @override
  Widget build(BuildContext context) {
    final areaProvider = context.watch<AreaProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final vehicleProvider = context.watch<VehicleProvider>();
    final count = notificationProvider.unreadCount;

    String locationText = "Madhapur, Hyderabad";
    if (areaProvider.selectedArea != null) {
      final area = areaProvider.selectedArea!;
      final cityName = area.city?.name ?? "";
      locationText = cityName.isNotEmpty ? "${area.name}, $cityName" : area.name;
    }

    final vehicle = vehicleProvider.vehicles.isNotEmpty ? vehicleProvider.vehicles.first : null;
    String statusMessage = "Add your vehicle to manage its daily service";
    if (vehicle != null) {
      final status = vehicle.status.toUpperCase();
      if (status == 'PENDING') {
        statusMessage = "Your vehicle verification is pending. Our inspector will review your vehicle details. Services will begin once the vehicle is approved.";
      } else if (status == 'APPROVED') {
        statusMessage = "Your vehicle is approved and ready for service.";
      } else if (status == 'REJECTED') {
        statusMessage = "Your vehicle verification was rejected. Please review the remarks and update the vehicle details.";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Location Selector & Notification Bell Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Location Selector
            GestureDetector(
              onTap: () {
                context.push('/select-area');
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFFFEBB1B),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    locationText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                    size: 20,
                  ),
                ],
              ),
            ),

            // Notification Bell
            GestureDetector(
              onTap: () async {
                await context.push('/notifications');
                if (mounted) {
                  context.read<NotificationProvider>().fetchUnreadCount();
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE9E9E9)),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            count > 9 ? '9+' : '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              height: 1,
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
        const SizedBox(height: 14),

        // Greeting section
        Text(
          _getGreeting(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
Text(
  statusMessage,
  style: TextStyle(
    fontSize: 14,
    color: Colors.grey.shade700,
    height: 1.4,
  ),
  softWrap: true,
  maxLines: null,
  overflow: TextOverflow.visible,
)
      ],
    );
  }
}
