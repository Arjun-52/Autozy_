import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      // Populate fields
      numberController.text = vehicle.vehicleNumber ?? '';
      sizeController.text = vehicle.sizeCategory ?? '';
      selectedMake = vehicle.brand;
      selectedModel = vehicle.model;
      selectedSize = vehicle.sizeCategory;
      latController.text = vehicle.parkingLocationLat?.toString() ?? '';
      lngController.text = vehicle.parkingLocationLng?.toString() ?? '';
      notesController.text = vehicle.parkingNotes ?? '';
    } catch (e) {
      AppLogger.error('Failed to load vehicle for edit', tag: 'Vehicles', error: e);
    } finally {
      setState(() => _isLoading = false);
    }
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
                  // LATITUDE
                  buildField(
                    label: "Parking Latitude",
                    focusNode: latFocus,
                    child: TextField(
                      controller: latController,
                      focusNode: latFocus,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: "eg. 17.3850", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // LONGITUDE
                  buildField(
                    label: "Parking Longitude",
                    focusNode: lngFocus,
                    child: TextField(
                      controller: lngController,
                      focusNode: lngFocus,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: "eg. 78.4867", border: InputBorder.none),
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
                              final lat = double.tryParse(latController.text.trim());
                              final lng = double.tryParse(lngController.text.trim());
                              if (lat == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Invalid latitude'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              if (lng == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Invalid longitude'), backgroundColor: Colors.redAccent));
                                return;
                              }

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
