import 'package:autozy/features/vehicles/widgets/add_vehicle_button.dart';
import 'add_vehicle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/vehicle_provider.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.user != null) {
        context.read<VehicleProvider>().refreshVehicles();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<VehicleProvider>();
      if (!provider.isListLoading && !provider.isPageLoading) {
        provider.loadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> openAddVehicle() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddVehicleScreen(),
    );

    if (result == true && mounted) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.user != null) {
        context.read<VehicleProvider>().refreshVehicles();
      }
    }
  }

  void deleteVehicle(String vehicleId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final vehicleProvider = context.read<VehicleProvider>();
    final authProvider = context.read<AuthProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Vehicle"),
          content: const Text("Are you sure you want to remove this vehicle?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;
    
    if (vehicleProvider.isListLoading || vehicleProvider.isPageLoading) return;

    final success = await vehicleProvider.deleteVehicle(vehicleId);
    
    if (success) {
      try {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Vehicle Removed Successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (_) {}
      
      authProvider.fetchUserProfile();
      if (authProvider.user != null) {
        await vehicleProvider.refreshVehicles();
      }
    } else {
      final errorMsg = vehicleProvider.error ?? "Something went wrong";
      try {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.redAccent,
          ),
        );
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final vehicles = vehicleProvider.vehicles;

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
      body: RefreshIndicator(
        onRefresh: () async {
          final authProvider = context.read<AuthProvider>();
          if (authProvider.user != null) {
            await vehicleProvider.refreshVehicles();
            await authProvider.fetchUserProfile();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: vehicleProvider.isListLoading && vehicles.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : vehicles.isEmpty
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
                            controller: _scrollController,
                            itemCount: vehicles.length + 1,
                            itemBuilder: (context, index) {
                              if (index == vehicles.length) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (vehicleProvider.isPageLoading)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        child: CircularProgressIndicator(),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                                      child: AddVehicleButton(
                                        onTap: () {
                                          openAddVehicle();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }

                              final vehicle = vehicles[index];

                              return GestureDetector(
                                onTap: () async {
                                  final updated = await context.push<bool>('/edit-vehicle/${vehicle.id}');
                                  if (updated == true && context.mounted) {
                                    context.read<VehicleProvider>().refreshVehicles();
                                  }
                                },
                                child: Padding(
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              vehicle.brand,
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
                                                    text: "${vehicle.vehicleNumber} ",
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
                                                    text: vehicle.sizeCategory,
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
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: vehicleProvider.isLoading
                                                ? null
                                                : () => deleteVehicle(vehicle.id),
                                            child: Opacity(
                                              opacity: vehicleProvider.isLoading ? 0.5 : 1.0,
                                              child: SvgPicture.asset(
                                                'assets/images/bin.svg',
                                                height: 24,
                                                width: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
