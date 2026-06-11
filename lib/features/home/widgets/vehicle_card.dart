import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/vehicle_provider.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final vehicles = vehicleProvider.vehicles;

    if (vehicles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
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
          children: [
            SvgPicture.asset(
              'assets/images/car2.svg',
              height: 40,
              width: 40,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            const SizedBox(height: 12),
            const Text(
              "No vehicles registered",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "Register your vehicle to manage services",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.pushNamed('vehicles');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCB2F),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Add Vehicle",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    }

    final vehicle = vehicles.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
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
          /// TOP ROW
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCB2F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: vehicleProvider.vehicles.isNotEmpty && vehicleProvider.vehicles.first.imageUrl != null && vehicleProvider.vehicles.first.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: vehicleProvider.vehicles.first.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                          errorWidget: (context, url, error) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset('assets/images/car2.svg'),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset('assets/images/car2.svg'),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${vehicle.brand} ${vehicle.model}",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Text(
                      "${vehicle.vehicleNumber} • ${vehicle.sizeCategory}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff7E8392),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              /// STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4FFF2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF008847)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/tick-mark.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Cleaned",
                      style: TextStyle(
                        color: Color(0xFF008847),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// MESSAGE BOX
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "✨ Your car was cleaned today at 7:15 AM",
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 10),

          /// WARNING TEXT
          const Text(
            "⚠️ If the car is not available at the scheduled time, Autozy is not responsible for the missed service.",
            style: TextStyle(color: Color(0xff7E8392), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
