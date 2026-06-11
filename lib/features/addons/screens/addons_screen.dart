import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'addon_datetime_selection.dart';
import '../../../providers/addon_service_provider.dart';
import '../../../core/utils/price_utils.dart';
 
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../providers/addon_booking_provider.dart';
import '../../../providers/home_provider.dart';
import '../../../data/models/dto/book_addon_request_model.dart';
import '../../../core/services/navigation_service.dart';

class AddonsScreen extends StatefulWidget {
  const AddonsScreen({super.key});

  @override
  State<AddonsScreen> createState() => _AddonsScreenState();
}

class _AddonsScreenState extends State<AddonsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddonServiceProvider>().fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddonServiceProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Add-ons",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(AddonServiceProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xffF4C430)));
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    final services = provider.services;
    if (services.isEmpty) {
      return Center(child: Text('No add-on services available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final s = services[index];
        final bookingProvider = context.watch<AddonBookingProvider>();
        return InkWell(
          onTap: () {
            // Navigate to book screen with selected service
            context.push('/book-addon', extra: {'serviceId': s.id, 'serviceName': s.name});
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      if (s.description != null) ...[
                        const SizedBox(height: 6),
                        Text(s.description!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatCurrency(s.price),
                      style: const TextStyle(color: Color(0xffC68A00), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    // Quick one-tap purchase button. Uses existing AddonBookingProvider to perform booking.
                    // Show booking progress while a booking is in progress to prevent duplicate taps
                    bookingProvider.isBooking
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xffC68A00),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : TextButton(
                                onPressed: () {
                                  // Open date/time selection screen via Navigator to keep app routing consistent
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddonDateTimeSelectionScreen(service: s)));
                                },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xffC68A00),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Buy Now', style: TextStyle(fontSize: 12)),
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGlobalSnack(String message, {Color background = Colors.red}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messenger = NavigationService.scaffoldMessengerKey.currentState;
      messenger?.showSnackBar(SnackBar(content: Text(message), backgroundColor: background));
    });
  }

  void _handleQuickBuy(BuildContext context, String serviceId) async {
    final vehicleProvider = context.read<VehicleProvider>();
    final areaProvider = context.read<AreaProvider>();
    final addonBookingProvider = context.read<AddonBookingProvider>();

    // Ensure prerequisites: vehicle and selected area (city)
    if (vehicleProvider.vehicles.isEmpty) {
      _showGlobalSnack('Please add a vehicle before purchasing add-ons', background: Colors.red);
      return;
    }

    final cityId = areaProvider.selectedArea?.cityId;
    if (cityId == null) {
      _showGlobalSnack('Please select an area before purchasing add-ons', background: Colors.red);
      return;
    }

    // Build a minimal booking request using current time as scheduled slot.
    final vehicleId = vehicleProvider.vehicles.first.id;
    final now = DateTime.now();
    final end = now.add(const Duration(hours: 1));
    String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    String _fmtTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

    final request = BookAddonRequestModel(
      vehicleId: vehicleId,
      addonServiceId: serviceId,
      scheduledDate: _fmtDate(now),
      scheduledSlotStart: _fmtTime(TimeOfDay(hour: now.hour, minute: now.minute)),
      scheduledSlotEnd: _fmtTime(TimeOfDay(hour: end.hour, minute: end.minute)),
      cityId: cityId,
    );

    // Confirmation dialog before making API call
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content: const Text('Are you sure you want to purchase this add-on?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirm')),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final success = await addonBookingProvider.bookAddon(request);
      if (success) {
        _showGlobalSnack('Add-on purchased successfully', background: Colors.green);
        // Refresh add-on list and bookings
        try {
          context.read<AddonServiceProvider>().fetchServices();
        } catch (_) {}
        try {
          addonBookingProvider.fetchBookings(isRefresh: true);
        } catch (_) {}
        // Refresh dashboard data if present
        try {
          context.read<HomeProvider>().fetchDashboard();
        } catch (_) {}
        // Navigate to My Add-on Bookings page
        if (context.mounted) context.push('/addon-bookings');
      } else {
        final err = addonBookingProvider.bookingError ?? 'Failed to book add-on';
        _showGlobalSnack(err, background: Colors.red);
      }
    } catch (e) {
      var msg = e.toString();
      if (msg.contains('Exception:')) msg = msg.replaceAll('Exception: ', '');
      _showGlobalSnack(msg, background: Colors.red);
    }
  }
}
