import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../data/models/dto/addon_service_model.dart';
import '../controllers/addon_booking_controller.dart';
import '../../../data/repositories/addon_repository.dart';
import 'addon_booking_summary.dart';
 
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../core/services/navigation_service.dart';

class AddonDateTimeSelectionScreen extends StatelessWidget {
  final AddonServiceModel service;

  const AddonDateTimeSelectionScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AddonRepository>();
    final controller = Get.put(AddonBookingController(repo));
    controller.setAddon(service);

    final vehicleProvider = context.read<VehicleProvider>();
    final areaProvider = context.read<AreaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Date & Time')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Calendar
            CalendarDatePicker(
              initialDate: DateTime.now().add(const Duration(days: 2)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: (d) {
                controller.setDate(d);
              },
              selectableDayPredicate: (day) {
                // disable past dates
                return !day.isBefore(DateTime.now().subtract(const Duration(days: 0)));
              },
            ),

            const SizedBox(height: 12),
            const Text('Select Time Slot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            Obx(() {
              final selected = controller.selectedTime.value;
              final slots = _generateTimeSlots();
              return Wrap(
                spacing: 8,
                children: slots.map((t) {
                  final isSelected = selected != null && selected.hour == t.hour && selected.minute == t.minute;
                  return ChoiceChip(
                    label: Text('${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}'),
                    selected: isSelected,
                    onSelected: (_) => controller.setTime(t),
                  );
                }).toList(),
              );
            }),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Ensure vehicle and area
                  if (vehicleProvider.vehicles.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final messenger = NavigationService.scaffoldMessengerKey.currentState;
                      messenger?.showSnackBar(const SnackBar(content: Text('Please add a vehicle before purchasing add-ons'), backgroundColor: Colors.red));
                    });
                    return;
                  }
                  final cityId = areaProvider.selectedArea?.cityId;
                  if (cityId == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final messenger = NavigationService.scaffoldMessengerKey.currentState;
                      messenger?.showSnackBar(const SnackBar(content: Text('Please select an area before purchasing add-ons'), backgroundColor: Colors.red));
                    });
                    return;
                  }

                  final dt = controller.combinedDateTime;
                  if (dt == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final messenger = NavigationService.scaffoldMessengerKey.currentState;
                      messenger?.showSnackBar(const SnackBar(content: Text('Please select date and time'), backgroundColor: Colors.red));
                    });
                    return;
                  }

                  if (!controller.isAtLeast48Hours()) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final messenger = NavigationService.scaffoldMessengerKey.currentState;
                      messenger?.showSnackBar(const SnackBar(content: Text('Add-on bookings must be 48+ hours in advance.'), backgroundColor: Colors.red));
                    });
                    return;
                  }

                  // Valid — go to summary
                  Get.to(() => AddonBookingSummaryScreen(vehicleProvider: vehicleProvider, areaProvider: areaProvider));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Continue', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TimeOfDay> _generateTimeSlots() {
    final List<TimeOfDay> slots = [];
    for (int h = 8; h <= 18; h++) {
      slots.add(TimeOfDay(hour: h, minute: 0));
      slots.add(TimeOfDay(hour: h, minute: 30));
    }
    return slots;
  }
}
