import 'package:autozy/features/vehicles/widgets/add_vehicle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'add_vehicle_screen.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  List<Map<String, String>> vehicles = [];

  Future<void> openAddVehicle() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddVehicleScreen(),
    );

    if (result != null) {
      setState(() {
        vehicles.add(Map<String, String>.from(result));
      });
    }
  }

  void deleteVehicle(int index) {
    setState(() {
      vehicles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/home?initialIndex=0');
          },
        ),
        title: const Text(
          "My Vehicles",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: vehicles.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AddVehicleButton(
                          onTap: () {
                            openAddVehicle();
                          },
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: vehicles.length + 1,
                      itemBuilder: (context, index) {
                        if (index == vehicles.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: AddVehicleButton(
                              onTap: () {
                                openAddVehicle();
                              },
                            ),
                          );
                        }

                        final vehicle = vehicles[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                /// ICON
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6C431),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: SvgPicture.asset(
                                        'assets/images/car2.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// TEXT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicle["make"] ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "${vehicle["number"]} ",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: "• ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: vehicle["size"] ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// RIGHT SIDE
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F8EF),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.green.shade300,
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 14,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Current",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () => deleteVehicle(index),
                                      child: SvgPicture.asset(
                                        'assets/images/bin.svg',
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
