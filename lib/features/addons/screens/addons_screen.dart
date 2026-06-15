import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'addon_datetime_selection.dart';
import '../../../providers/addon_service_provider.dart';
import '../../../core/utils/price_utils.dart';
import '../../../data/models/dto/addon_service_model.dart';
 
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vehicleProvider = context.read<VehicleProvider>();
      if (vehicleProvider.vehicles.isEmpty) {
        await vehicleProvider.fetchVehicles(page: 1, limit: 20, reset: true);
      }
      _fetchAddonServices();
    });
  }

  void _fetchAddonServices() {
    final areaProvider = context.read<AreaProvider>();
    final vehicleProvider = context.read<VehicleProvider>();
    final cityId = areaProvider.selectedArea?.cityId;
    final vehicleSize = vehicleProvider.vehicles.isNotEmpty
        ? vehicleProvider.vehicles.first.sizeCategory
        : null;

    if (cityId != null && vehicleSize != null) {
      context.read<AddonServiceProvider>().fetchServices(
            cityId: cityId,
            vehicleSize: vehicleSize,
          );
    }
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
    final areaProvider = context.watch<AreaProvider>();
    final vehicleProvider = context.watch<VehicleProvider>();
    final cityId = areaProvider.selectedArea?.cityId;

    if (cityId == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Please select a service area first to view available add-ons.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      );
    }

    if (vehicleProvider.vehicles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please add a vehicle to view available add-ons.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pushNamed('addVehicle'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffC68A00)),
                child: const Text('Add Vehicle', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xffF4C430)));
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchAddonServices,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffC68A00)),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final services = provider.services;
    if (services.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No add-on services available for your vehicle size and location.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final s = services[index];
        final bookingProvider = context.watch<AddonBookingProvider>();
        return InkWell(
          onTap: () {
            context.push('/book-addon', extra: {
              'serviceId': s.id,
              'serviceName': s.name,
              'pricingId': s.pricingId,
            });
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
                      if (s.estimatedDuration != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              "${s.estimatedDuration} mins",
                              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
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

}
