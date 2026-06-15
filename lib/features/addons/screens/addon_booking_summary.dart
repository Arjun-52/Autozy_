import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../controllers/addon_booking_controller.dart';
import '../../../core/router/go_router.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../providers/addon_booking_provider.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/services/navigation_service.dart';

class AddonBookingSummaryScreen extends StatelessWidget {
  final VehicleProvider vehicleProvider;
  final AreaProvider areaProvider;

  const AddonBookingSummaryScreen({super.key, required this.vehicleProvider, required this.areaProvider});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddonBookingController>();
    final addon = controller.addon.value!;
    final vehicle = vehicleProvider.vehicles.isNotEmpty ? vehicleProvider.vehicles.first : null;

    final dt = controller.combinedDateTime;
    final dateStr = dt != null ? '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}' : '-';
    final timeStr = dt != null ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}' : '-';

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(addon.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Price: ${formatCurrency(addon.price)}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Selected Date: $dateStr'),
            Text('Selected Time: $timeStr'),
            const SizedBox(height: 12),
            if (vehicle != null) ...[
              Text('Vehicle: ${vehicle.name} (${vehicle.number})'),
              const SizedBox(height: 12),
            ],
            const Spacer(),
            Text('Total: ${formatCurrency(addon.price)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isBooking.value
                      ? null
                      : () async {
                          try {
                            final cityId = areaProvider.selectedArea?.cityId ?? '';
                            final vehicleId = vehicle?.id ?? '';
                            final success = await controller.bookAddon(vehicleId: vehicleId, cityId: cityId);
                            if (success) {
                              if (context.mounted) {
                                context.read<AddonBookingProvider>().fetchBookings(isRefresh: true);
                              }
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                final messenger = NavigationService.scaffoldMessengerKey.currentState;
                                messenger?.showSnackBar(const SnackBar(content: Text('Add-on booked successfully.'), backgroundColor: Colors.green));
                              });
                              Get.off(() => AddonBookingSuccessScreen());
                            }
                          } catch (e) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              final messenger = NavigationService.scaffoldMessengerKey.currentState;
                              messenger?.showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                            });
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: controller.isBooking.value ? const CircularProgressIndicator(color: Colors.white) : const Text('Proceed to Payment'),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class AddonBookingSuccessScreen extends StatelessWidget {
  const AddonBookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddonBookingController>();
    final booking = controller.bookingResponse?.data;
    final addon = controller.addon.value;
    final scheduled = booking != null ? '${booking.scheduledDate} ${booking.scheduledSlotStart}' : '-';

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Success')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 72),
            const SizedBox(height: 12),
            Text('Booking ID: ${booking?.id ?? '-'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Add-on: ${addon?.name ?? '-'}'),
            const SizedBox(height: 8),
            Text('Scheduled: $scheduled'),
            const SizedBox(height: 8),
            Text('Payment Status: Success'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to home using GoRouter
                  AppGoRouter.router.go('/home');
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Back to Home'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
