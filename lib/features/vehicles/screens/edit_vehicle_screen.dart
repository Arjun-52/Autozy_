import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'map_picker_screen.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/dto/update_vehicle_request.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../data/models/vehicle_model.dart';

class EditVehicleScreen extends StatefulWidget {
  final String vehicleId;
  const EditVehicleScreen({Key? key, required this.vehicleId}) : super(key: key);

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final numberController = TextEditingController();
  final sizeController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final notesController = TextEditingController();

  final numberFocus = FocusNode();
  final latFocus = FocusNode();
  final lngFocus = FocusNode();
  final notesFocus = FocusNode();

  String? selectedMake;
  String? selectedModel;
  String? selectedSize;

  final Map<String, List<String>> carModels = {
    "Hyundai": ["Creta", "i20", "Verna"],
    "Honda": ["City", "Civic"],
    "Toyota": ["Innova", "Fortuner"],
  };

  bool _isLoading = false;
  bool _isDetectingLocation = false;
  String? _selectedAddress;
  Vehicle? _vehicle;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  Future<void> _loadVehicle() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<VehicleProvider>();
      final vehicle = await provider.getVehicleById(widget.vehicleId);
      _vehicle = vehicle;
      // Populate fields
      numberController.text = vehicle.vehicleNumber ?? '';
      sizeController.text = vehicle.sizeCategory ?? '';
      selectedMake = vehicle.brand;
      selectedModel = vehicle.model;
      selectedSize = vehicle.sizeCategory;
      latController.text = vehicle.parkingLocationLat?.toString() ?? '';
      lngController.text = vehicle.parkingLocationLng?.toString() ?? '';
      notesController.text = vehicle.parkingNotes ?? '';
      
      String address = "Coordinates configured";
      if (vehicle.parkingLocationLat != 0.0 && vehicle.parkingLocationLng != 0.0) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            vehicle.parkingLocationLat,
            vehicle.parkingLocationLng,
          );
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks.first;
            List<String> parts = [];
            if (place.name != null && place.name!.isNotEmpty && place.name != place.street) {
              parts.add(place.name!);
            }
            if (place.street != null && place.street!.isNotEmpty) {
              parts.add(place.street!);
            }
            if (place.subLocality != null && place.subLocality!.isNotEmpty) {
              parts.add(place.subLocality!);
            }
            if (place.locality != null && place.locality!.isNotEmpty) {
              parts.add(place.locality!);
            }
            if (parts.isNotEmpty) {
              address = parts.join(', ');
            }
          }
        } catch (geocodeErr) {
          AppLogger.error('Geocoding error on loading vehicle', error: geocodeErr);
        }
      }
      setState(() {
        _selectedAddress = address;
      });
    } catch (e) {
      AppLogger.error('Failed to load vehicle for edit', tag: 'Vehicles', error: e);
    } finally {
      setState(() => _isLoading = false);
    }
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
        horizontal: 12,
        vertical: 6,
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
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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

  @override
  void dispose() {
    numberController.dispose();
    sizeController.dispose();
    latController.dispose();
    lngController.dispose();
    notesController.dispose();
    numberFocus.dispose();
    latFocus.dispose();
    lngFocus.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final authProvider = context.read<AuthProvider>();
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vehicle'),
        backgroundColor: const Color(0xFFF6C431),
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_vehicle != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildStatusBadge(_vehicle!.status),
                    ),
                    const SizedBox(height: 12),
                    if (_vehicle!.status.toLowerCase() == 'rejected') ...[
                      _buildRejectionReasonCard(_vehicle!.rejectionReason),
                      const SizedBox(height: 16),
                    ],
                    // Vehicle Image
                    if (_vehicle!.imageUrl != null && _vehicle!.imageUrl!.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: _vehicle!.imageUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            color: Colors.grey.shade200,
                            child: Center(child: SvgPicture.asset('assets/images/car2.svg')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: SvgPicture.asset('assets/images/car2.svg')),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                  // Vehicle Number (read‑only, cannot change)
                  buildField(
                    label: "Vehicle Number",
                    focusNode: null,
                    child: TextField(
                      controller: numberController,
                      enabled: false,
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // MAKE
                  buildField(
                    label: "Select Make",
                    focusNode: null,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMake,
                        hint: const Text("Select Make"),
                        isExpanded: true,
                        items: carModels.keys
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMake = value;
                            selectedModel = null;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // MODEL
                  buildField(
                    label: "Select Model",
                    focusNode: null,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedModel,
                        hint: const Text("Select Model"),
                        isExpanded: true,
                        items: (carModels[selectedMake] ?? [])
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedModel = value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // SIZE (read-only, cannot change)
                  buildField(
                    label: "Size Category",
                    focusNode: null,
                    child: TextField(
                      controller: sizeController,
                      enabled: false,
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // PARKING LOCATION SELECTOR CARD
                  buildField(
                    label: "Parking Location",
                    focusNode: null,
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.push<MapPickerResult>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPickerScreen(
                              initialLat: double.tryParse(latController.text),
                              initialLng: double.tryParse(lngController.text),
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            latController.text = result.latitude.toString();
                            lngController.text = result.longitude.toString();
                            _selectedAddress = result.address;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.map, color: Color(0xFFF6C431)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedAddress ?? (_isDetectingLocation ? "Updating location..." : "Tap to select parking location"),
                                    style: TextStyle(
                                      fontWeight: _selectedAddress != null ? FontWeight.w600 : FontWeight.normal,
                                      color: _selectedAddress != null ? Colors.black : Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_isDetectingLocation)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFF6C431)),
                              )
                            else
                              const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // NOTES
                  buildField(
                    label: "Parking Notes",
                    focusNode: notesFocus,
                    child: TextField(
                      controller: notesController,
                      focusNode: notesFocus,
                      decoration: const InputDecoration(hintText: "eg. Parked near apartment gate", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: vehicleProvider.isLoading || vehicleProvider.patchStatus == 'loading'
                          ? null
                          : () async {
                              // Validate fields (similar to AddVehicleScreen)
                              if (selectedMake == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Vehicle make is required'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              if (selectedModel == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Vehicle model is required'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              if (selectedSize == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Vehicle size is required'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              if (_selectedAddress == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Please select a parking location on the map'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              final lat = double.tryParse(latController.text.trim()) ?? 17.3850;
                              final lng = double.tryParse(lngController.text.trim()) ?? 78.4867;

                              final request = UpdateVehicleRequest(
                                brand: selectedMake,
                                model: selectedModel,
                                parkingLocationLat: lat,
                                parkingLocationLng: lng,
                                parkingNotes: notesController.text.trim(),
                              );

                              final success = await vehicleProvider.patchVehicle(widget.vehicleId, request);
                              if (success) {
                                // Refresh user profile counts if needed
                                authProvider.fetchUserProfile();
                                navigator.pop(true);
                              } else {
                                scaffoldMessenger.showSnackBar(SnackBar(content: Text(vehicleProvider.error ?? 'Patch failed'), backgroundColor: Colors.redAccent));
                              }
                            },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF6C431), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: vehicleProvider.patchStatus == 'loading'
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('Update Vehicle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildField({required String label, required Widget child, required FocusNode? focusNode}) {
    return BorderFocusField(
      label: label,
      focusNode: focusNode,
      child: child,
    );
  }
}

class BorderFocusField extends StatefulWidget {
  final String label;
  final Widget child;
  final FocusNode? focusNode;

  const BorderFocusField({
    super.key,
    required this.label,
    required this.child,
    required this.focusNode,
  });

  @override
  State<BorderFocusField> createState() => _BorderFocusFieldState();
}

class _BorderFocusFieldState extends State<BorderFocusField> {
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocusChange);
    _hasFocus = widget.focusNode?.hasFocus ?? false;
  }

  @override
  void didUpdateWidget(covariant BorderFocusField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      widget.focusNode?.addListener(_onFocusChange);
      _hasFocus = widget.focusNode?.hasFocus ?? false;
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    final newFocus = widget.focusNode?.hasFocus ?? false;
    if (_hasFocus != newFocus) {
      setState(() {
        _hasFocus = newFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hasFocus ? const Color(0xFFF6C431) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          widget.child,
        ],
      ),
    );
  }
}
