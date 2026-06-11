import 'package:autozy/features/vehicles/widgets/add_vehicle_button.dart';
import 'add_vehicle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  Widget _buildRejectionReasonCard(String? reason) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade800, size: 18),
              const SizedBox(width: 6),
              const Text(
                "Status: Rejected",
                style: TextStyle(
                  color: Color(0xFF991B1B),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Reason:\n${reason ?? 'Vehicle verification failed. Please review your vehicle details.'}",
            style: const TextStyle(
              color: Color(0xFF991B1B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = const Color(0xFFE8F8EF);
        borderColor = Colors.green.shade300;
        textColor = Colors.green;
        icon = Icons.check_circle;
        text = "Approved";
        break;
      case 'rejected':
        bgColor = const Color(0xFFFEE2E2);
        borderColor = Colors.red.shade300;
        textColor = Colors.red;
        icon = Icons.cancel;
        text = "Rejected";
        break;
      case 'pending':
      default:
        bgColor = const Color(0xFFFFF9E6);
        borderColor = Colors.amber.shade300;
        textColor = const Color(0xFFD97706);
        icon = Icons.hourglass_empty;
        text = "Inspection Pending";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          /// ICON / Vehicle Photo
                                          Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF6C431),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(14),
                                              child: vehicle.imageUrl != null && vehicle.imageUrl!.isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl: vehicle.imageUrl!,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                                                      errorWidget: (context, url, error) => Padding(
                                                        padding: const EdgeInsets.all(8.0),
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
                                              _buildStatusBadge(vehicle.status),
                                               const SizedBox(height: 10),
                                               Row(
                                                 mainAxisSize: MainAxisSize.min,
                                                 children: [
                                                   GestureDetector(
                                                     onTap: () {
                                                       context.push('/service-history/${vehicle.id}');
                                                     },
                                                     child: const Row(
                                                       children: [
                                                         Icon(
                                                           Icons.history,
                                                           size: 16,
                                                           color: Color(0xFFC68A00),
                                                         ),
                                                         SizedBox(width: 4),
                                                         Text(
                                                           "History",
                                                           style: TextStyle(
                                                             color: Color(0xFFC68A00),
                                                             fontSize: 12,
                                                             fontWeight: FontWeight.w600,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                   const SizedBox(width: 14),
                                                   GestureDetector(
                                                     onTap: () {
                                                       context.push('/service-calendar/${vehicle.id}');
                                                     },
                                                     child: const Row(
                                                       children: [
                                                         Icon(
                                                           Icons.calendar_month,
                                                           size: 16,
                                                           color: Color(0xFFC68A00),
                                                         ),
                                                         SizedBox(width: 4),
                                                         Text(
                                                           "Calendar",
                                                           style: TextStyle(
                                                             color: Color(0xFFC68A00),
                                                             fontSize: 12,
                                                             fontWeight: FontWeight.w600,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                   const SizedBox(width: 14),
                                                   GestureDetector(
                                                     onTap: vehicleProvider.isLoading
                                                          ? null
                                                          : () => deleteVehicle(vehicle.id),
                                                     child: Opacity(
                                                       opacity: vehicleProvider.isLoading ? 0.5 : 1.0,
                                                       child: SvgPicture.asset(
                                                         'assets/images/bin.svg',
                                                         height: 20,
                                                         width: 20,
                                                       ),
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (vehicle.status.toLowerCase() == 'rejected') ...[
                                        const SizedBox(height: 12),
                                        _buildRejectionReasonCard(vehicle.rejectionReason),
                                      ],
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
